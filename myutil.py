import web3
from web3.middleware import geth_poa_middleware
import solc
import time
import threading
import hashlib
import os

w3 = None
HOST="172.18.0.2"
PORT="8545"

cache = {}

def connect(host=None,port=None,poa=False):
    global w3
    if host is None:
        host=HOST
    if port is None:
        port=PORT
    if w3 is None or not w3.isConnected():
        w3 = web3.Web3(web3.HTTPProvider(f"http://{host}:{port}"))
        if poa:
            # inject PoA compatibility
            w3.middleware_stack.inject(geth_poa_middleware, layer=0)
    assert w3.isConnected()
    return w3


def filehash(path):
    with open(path, 'rb') as f:
        return hashlib.md5(f.read()).hexdigest()


def compile_contract(path):
    """ compiles a single contract from path
        and returns its ABI interface.
    """
    h = filehash(path)
    interface = cache.get(h)
    if interface:
        return interface

    with open(path) as f:
        src = f.read()#
    compiler_output = solc.compile_source(src).values()
    if len(compiler_output) == 1:
        for interface in compiler_output:
            cache[h] = interface
            return interface
    else:
        print("Error: compiled more than one contract?")
        return None

def deploy_contract(cabi,cbin,account=None,gas=None):
    """ deploy contract from JSON ABI and binary hex string (bin)
        which includes deployment constructor.
        Optinal argument account from which deployment tx is sent
    """
    if account is None:
        account = w3.eth.accounts[0]
        w3.eth.defaultAccount = account
    if gas is None:
        # somewhere around max gas
        gas = 5_000_000

    contract=w3.eth.contract(abi=cabi,
                             bytecode=cbin)

    tx_hash = contract.constructor().transact({"from":account,
                                               "gas":gas})
    tx_receipt = w3.eth.waitForTransactionReceipt(tx_hash)
    return tx_receipt

def get_contract_instance(caddress,cabi,account=None,concise=False,patch_api=False,concise_events=False):
    """ get contract instance from address and abi """

    if concise:
        instance = w3.eth.contract(
            address=caddress,
            abi=cabi,
            ContractFactoryClass=web3.contract.ConciseContract)
    else:
        instance = w3.eth.contract(
            address=caddress,
            abi=cabi)

    if concise and patch_api:
        #if concise and patch_api:
        # patch API s.t. all transactions are automatically waited for
        # until tx_receipt is received
        for name, func in instance.__dict__.items():
            if isinstance(func, web3.contract.ConciseMethod):
                instance.__dict__[name] = _tx_executor(func)

    if concise and concise_events:
        dummy_instance = w3.eth.contract(
            address=caddress,
            abi=cabi)
        instance.eventFilter = dummy_instance.eventFilter
        instance.events = dummy_instance.events

    return instance

def _tx_executor(contract_function):
    """ modifies the contract instance interface function such that whenever a transaction is performed
        it automatically waits until the transaction in included in the blockchain
        (unless wait=False is specified, in the case the default the api acts as usual)
    """
    def f(*args, **kwargs):
        wait = kwargs.pop("wait", True)
        txwait = kwargs.pop("txwait", False)
        if ("transact" in kwargs and wait) or txwait:
            tx_hash = contract_function(*args, **kwargs)
            tx_receipt = w3.eth.waitForTransactionReceipt(tx_hash)
            return tx_receipt
        return contract_function(*args, **kwargs)
    return f


def compile_and_deploy_contract(path, account=None, concise=True, patch_api=True,concise_events=True):
    """ compiles and deploy the given contract (from the ./contracts folder)
        returns the contract instance
    """
    if not w3 or not w3.isConnected():
        connect()
    if account is None:
        account = w3.eth.accounts[0]
        w3.eth.defaultAccount = account

    interface = compile_contract(path)
    receipt = deploy_contract(cabi=interface["abi"],cbin=interface["bin"])
    contract = get_contract_instance(caddress=receipt['contractAddress'],
                                     cabi=interface["abi"],
                                     patch_api=patch_api,
                                     concise=concise,
                                     concise_events=concise_events)
    return contract


def get_events(contract_instance, event_name):
    # eventFilter = contract.eventFilter(event_name, {"fromBlock": 0})
    eventFilter = contract_instance.events.__dict__[event_name].createFilter(fromBlock=0)
    return [e for e in eventFilter.get_all_entries() if e.address == contract_instance.address]


def mine_block():
    w3.providers[0].make_request('evm_mine', params='')

def mine_blocks_until(predicate):
    while not predicate():
        mine_block()

def wait_for(predicate, check_interval=1.0):
    while not predicate():
        time.sleep(check_interval)

