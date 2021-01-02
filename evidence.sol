/*
	** author:hkxia
	** 2020-10-8

	视频版权存证场景的智能合约
	
	“存证”即“保全”，保全即证据固定与保管，是指用一定的形式将证据固定下来，加以妥善保管，以供司法人员或律师、认定案件事实时使用。
	
	文件hash一旦通过该合约存入区块链便不可删除和修改，可用于证明电子合同等法律文书的有效性。
*/
pragma solidity 0.4.11^;
contract Evidence{
    uint CODE_SUCCESS = 0;
    uint FILE_NOT_EXIST = 3002;
    uint FILE_ALREADY_EXIST  = 3003;
    uint USER_NOT_EXIST = 3004;

    struct FileEvidence{
    bytes fileHash;
    uint fileUploadTime;
    address owner;
    }
    struct User{
        address addr;
        uint count;
        mapping(bytes => FileEvidence) filemap;
    }
    
    // 文件hash对应的文件存证实体
    mapping(bytes => FileEvidence) fileEvidenceMap;
    
    // 交易hash对应的文件存证实体
    mapping(bytes => FileEvidence) tx2FileEvidenceMap;
    
    mapping(address => User) userMap;
    
    address[] userList;
    
    //保存文件hash，文件hash会被保存到调用者的存证空间下；
    function saveEvidence(bytes fileHash,uint fileUploadTime) returns(uint code){
        //get filemap under sender
        User storage user = userMap[msg.sender];
        
        if (user.addr == 0x0) {
            user.addr = msg.sender;
            userList.push(msg.sender);
        } 
        FileEvidence storage fileEvidence = user.filemap[fileHash];
        if(fileEvidence.fileHash.length != 0){
            return FILE_ALREADY_EXIST;
        }
        user.count += 1;
        fileEvidence.fileHash = fileHash;
        fileEvidence.fileUploadTime = fileUploadTime;
        fileEvidence.owner = msg.sender;
        user.filemap[fileHash] = fileEvidence;
        return CODE_SUCCESS;
    }
    
    //从调用者的存证空间中搜索该hash，若搜索到便返回响应的存证详情，否则返回搜索失败的相应提示；
    function getEvidence(bytes fileHash) returns(uint code,bytes fHash,uint fUpLoadTime,address saverAddress) {
        //get filemap under sender
        User storage user = userMap[msg.sender];
        if (user.addr == 0x0) {
            return (USER_NOT_EXIST,"",0,msg.sender);
        } 
        FileEvidence memory fileEvidence = user.filemap[fileHash];
        if(fileEvidence.fileHash.length == 0){
            return (FILE_NOT_EXIST,"",0,msg.sender);
        }
        
        return(CODE_SUCCESS,fileEvidence.fileHash,fileEvidence.fileUploadTime,msg.sender);
    }
    
    //查询用户列表，新的区块链账户若发起过saveEvidence请求，该账户便会被计入该列表。
    function getUsers() returns(address[] users){
        return userList;
    }
}
