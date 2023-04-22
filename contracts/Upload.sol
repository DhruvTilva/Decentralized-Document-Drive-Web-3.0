// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract Upload{
//0x.....
    struct Access{
        address user;
        bool access; //yes or no true or false 

    }
    mapping(address=>string[])value;
    mapping(address=>mapping(address=>bool))ownership;
    mapping(address=>Access[]) accessList;
    mapping(address=>mapping(address=>bool)) previousData;

    function add(address _user,string memory url) external {
        value[_user].push(url);
    }

    function allow(address user) external { //def
        ownership[msg.sender][user]=true;
        if(previousData[msg.sender][user]){ //check previous def is true but by deaflaut it is false then check else condition
            for(uint i=0;i<accessList[msg.sender].length;i++){
                if(accessList[msg.sender][i].user==user){
                    accessList[msg.sender][i].access=true;   //true
                }
            }
        }else{
             accessList[msg.sender].push(Access(user,true)); //true then false after run disallow //then def.access ==true
             previousData[msg.sender][user]=true; //true not change previous data
        }
    }

    function disallow(address user) public {
        ownership[msg.sender][user]=false;
        for(uint i=0;i<accessList[msg.sender].length;i++){
            if(accessList[msg.sender][i].user==user){ //check true user value or not
                accessList[msg.sender][i].access=false; //false

            }
        }
    }

    function display(address _user) external view returns(string[] memory){
        require(_user==msg.sender || ownership[_user][msg.sender],"Sorry! You Do NOt Have Access");
        return value[_user];
    }

    function shareAccess() public view returns(Access[] memory){
        return accessList[msg.sender];
    }

}