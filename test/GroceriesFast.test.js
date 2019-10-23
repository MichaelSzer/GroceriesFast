const GroceriesFast = artifacts.require("GroceriesFast");
const Order = artifacts.require("Order");

contract("GroceriesFast", accounts => {
    it("should create an order with the name 'Michael' and a reward of 1 ether.", async () => {
        let groceriesFast = await GroceriesFast.deployed();
        
        await groceriesFast.createOrder("Michael", web3.utils.toWei("1"));
        let orderAdrress = await groceriesFast.getOrderAddress(0);

        const order = new web3.eth.Contract(Order.abi, orderAdrress);

        let name = await order.methods.name().call();
        let reward = await order.methods.reward().call();

        assert.equal(name, "Michael", "order's name is not Michael");
        assert.equal(web3.utils.fromWei(reward), "1", "order's reward is not 1 ether"); 
    });

    it("should create an order and add an item ( product: 'Milk', price: 5 ).", async () => {
        let groceriesFast = await GroceriesFast.deployed();
        
        await groceriesFast.createOrder("Michael", web3.utils.toWei("1"));
        let orderAdrress = await groceriesFast.getOrderAddress(0);

        const order = new web3.eth.Contract(Order.abi, orderAdrress);

        await order.methods.addItem("Milk", 5).send({ from: accounts[0] });
        let item = await order.methods.items(0).call();

        assert.equal(item.product, "Milk", "item's product should be 'Milk'");
        assert.equal(item.price, 5, "item's price should be 5");
    });
});