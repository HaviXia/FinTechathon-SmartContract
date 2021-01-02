
pragma solidity 0.4.11^;
contract Digitalpoint {

    /*
     * author : hkxia   
     * 2020-10-6  
    */
    /*
        四个机构共同构成了一个跨机构积分联盟，消费者经任一机构消费获得该机构发行的积分，消费者之间可将不同机构发行的积分通过`exchangepoints`方法进行交换，
        也可通过`pointstransaction`方法消耗积分兑换商品。商品通过`newCommodity`方法发布上市。
        消费者可通过办理Bilibili大会员的方式参与积分活动获得积分，也可通过短视频打赏消费获得积分，并使用获得的积分进行Xgshipin商品兑换或至Kuaishou兑换优惠券。
        积分联盟最终为西瓜视频或快手平台提供积分兑现，完成积分和客户资源的流转。
    */
    enum Actor{ Bilibili, Douyin, Xgshipin, Kuaishou, Client }
    
    struct Bilibili{
        bytes32 ID;
        bytes32 Name;
        uint pointbalance;
    }
    
    struct Douyin{
        bytes32 ID;
        bytes32 Name;
        uint pointbalance;
    }
    
    struct Xgshipin{
        bytes32 ID;
        bytes32 Name;
        uint pointbalance;
    }
    
    struct Kuaishou{
        bytes32 ID;
        bytes32 Name;
        uint pointbalance;
    }
    
    //用户消费者
    struct Client{
        bytes32 ID;
        bytes32 Name;
        uint[] pointbalances;
        uint unionpaybalance;
    }
    
    //商品
    struct Commodity{
        bytes32 ID;
        bytes32 Name;
        uint value;
    }
    
    mapping(bytes32 => Bilibili) bilibiliMap;
    mapping(bytes32 => Douyin) douyinMap;
    mapping(bytes32 => Xgshipin) xgshipinMap;
    mapping(bytes32 => Kuaishou) kuaishouMap;
    mapping(bytes32 => Client) clientMap;
    mapping(bytes32 => Commodity) commodityMap;
    
    function newBilibili(bytes32 ID, bytes32 Name, uint pointbalance) returns (bool, bytes32){
        Bilibili bilibili = bilibiliMap[ID];
        if(bilibili.ID != 0x0){
            return (false,"this ID has been occupied!");
        }
        bilibili.ID = ID;
        bilibili.Name = Name;
        bilibili.pointbalance = pointbalance;
        return (true,"success");
    }
    
    function newDouyin(bytes32 ID, bytes32 Name, uint pointbalance) returns (bool, bytes32){
        Douyin douyin = douyinMap[ID];
        if(douyin.ID != 0x0){
            return (false,"this ID has been occupied!");
        }
        douyin.ID = ID;
        douyin.Name = Name;
        douyin.pointbalance = pointbalance;
        return (true,"success");
    }
    
    function newXgshipin(bytes32 ID, bytes32 Name, uint pointbalance) returns (bool, bytes32){
        Xgshipin xgshipin = xgshipinMap[ID];
        if(xgshipin.ID != 0x0){
            return (false,"this ID has been occupied!");
        }
        xgshipin.ID = ID;
        xgshipin.Name = Name;
        xgshipin.pointbalance = pointbalance;
        return (true,"success");
    }
    
    function newKuaishou(bytes32 ID, bytes32 Name, uint pointbalance) returns (bool, bytes32){
        Kuaishou kuaishou = kuaishouMap[ID];
        if(kuaishou.ID != 0x0){
            return (false,"this ID has been occupied!");
        }
        kuaishou.ID = ID;
        kuaishou.Name = Name;
        kuaishou.pointbalance = pointbalance;
        return (true,"success");
    }
    
    function newCommodity(bytes32 ID, bytes32 Name, uint value) returns (bool, bytes32){
        Commodity commodity = commodityMap[ID];
        if(commodity.ID != 0x0){
            return (false,"this ID has been occupied!");
        }
        commodity.ID = ID;
        commodity.Name = Name;
        commodity.value = value;
        return (true,"success");
    }
    
    function newClient(bytes32 ID, bytes32 Name, uint[] pointbalances, uint unionpaybalance) returns (bool, bytes32){
        Client client = clientMap[ID];
        if(client.ID != 0x0){
            return (false,"this ID has been occupied!");
        }
        client.ID = ID;
        client.Name = Name;
        client.pointbalances = pointbalances;
        client.unionpaybalance = unionpaybalance;
        return (true,"success");
    }
    
    function Queryclientbalance(bytes32 ID) returns(bool,bytes32,bytes32,uint[],uint){
        Client client = clientMap[ID];
        return (true,"Success",client.Name,client.pointbalances,client.unionpaybalance);
    }
    
    function exchangeMoneyToPoints(bytes32 ID,uint amount,uint n) returns(bool,bytes32){
        Client client = clientMap[ID];
        client.unionpaybalance -= amount;
        client.pointbalances[n-1] += amount;
        return (true,"success");
    }
    
    // 平台积分的交换
    function exchangepoints(bytes32 ID1, uint amount1, uint n, bytes32 ID2, uint amount2, uint m) returns(bool, bytes32){
        Client client1 = clientMap[ID1];
        Client client2 = clientMap[ID2];
        client1.pointbalances[n-1] -= amount1;
        client2.pointbalances[n-1] += amount1;
        client1.pointbalances[m-1] += amount2;
        client2.pointbalances[m-1] -= amount2;
        return (true,"success");
    }
    // 消耗积分换商品
    function pointstransaction(bytes32 ID1, uint n, bytes32 ID2) returns(bool, bytes32){
        Client client1 = clientMap[ID1];
        Commodity commodity = commodityMap[ID2];
        client1.pointbalances[n-1] -= commodity.value;
        return (true,"Purchase succeeded");
    }
}