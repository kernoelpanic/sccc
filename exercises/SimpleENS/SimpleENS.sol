pragma solidity ^0.4.0;
 
contract SimpleENS {
    struct Record {
        address owner;
        string ipaddr;
    }
 
    mapping (string => Record) public records;
    
    function setDomain(string _domain, string _ipaddr) public {
		// Register new domain or update existing mapping if owner
        require( records[_domain].owner == address(0x0) ||	 
  				 records[_domain].owner == msg.sender ); 
        
        records[_domain] = Record(msg.sender, _ipaddr);
    }
    
    function getDomain(string _domain) view public returns(string) {
		// Get the current mapping of a domain name
        return records[_domain].ipaddr;
    }
    
    function transferDomain(string _domain, address _to) public {
		// Transfer ownership of domain to another address 
        require( records[_domain].owner == msg.sender );
        records[_domain].owner = _to;
    }    
}
