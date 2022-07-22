// SPDX-License-Identifier: Unlicensed
pragma solidity ^0.8.7;

//CONTRACT FOR AN NFT MARKET PLACE THAT ALLOWS THE USER TO MINT A TOKEN
//SELL A TOKEN AND BUY A TOKEN WITH A FEW ADDED FUNCTIONALITIES LIKE FETCH ALL ITEMS FOR SALE  
//AND FETCH OWNED ITEMS

//counter utility that makes it easy to create a number and increment it
import "@openzeppelin/contracts/utils/Counters.sol";
//ERC721 + settokenuri which lets us set the uri of the asset itself
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
//Allows us to add nonereentrance modifer so we can call one contract to another to prevent re-entry attacks
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

import "hardhat/console.sol";

//Inheriting from this import
contract NFT is ERC721URIStorage {
    //The using A for B; directive means we attach library functions( from the library A to any type B).
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    address contractAddress;

    constructor(address marketplaceAddress) ERC721("Stan's Digital marketplace", "NDM"){
        contractAddress = marketplaceAddress;
    }


    //Remember memory is a temporary place to store data
    //Function to mint tokens
    function createToken(string memory tokenURI) public returns (uint) {
        _tokenIds.increment();
        //unique identifier for token
        uint256 newItemId = _tokenIds.current();

        //Mint
        _mint(msg.sender, newItemId);
        _setTokenURI(newItemId, tokenURI);
        setApprovalForAll(contractAddress, true);
        //need token id to call and retrieve for client side
        return newItemId;
    }



}

contract NFTMarket is ReentrancyGuard{
    using Counters for Counters.Counter;
    Counters.Counter private _itemIds;
    Counters.Counter private _itemsSold;

    address payable owner;
    // uint256 listingPrice = 0.1 ether;
    uint256 listingPrice = 10 ether;

    constructor(){
        owner = payable(msg.sender);
    }

    struct MarketItem{
        uint itemId;
        address nftContract;
        uint256 tokenId;
        address payable seller;
        address payable owner;
        uint256 price;
    }

    //creating an array of structs
    mapping(uint256 => MarketItem) private idToMarketItem;

    event MarketItemCreated (
        uint indexed itemId,
        address indexed nftContract,
        uint256 indexed tokenId,
        address seller,
        address owner,
        uint256 price
    );

    //Creating an item to sell on the market
    function createMarketItem(address nftContract,uint256 tokenId,uint256 price) public payable nonReentrant {
        require(price > 0, "Price must be at least 1 wei");
        require(msg.value >= listingPrice, "Price must be greater than or equal to listing price!");

        _itemIds.increment();
        uint256 itemId = _itemIds.current();


        idToMarketItem[itemId] = MarketItem(
            itemId,
            nftContract,
            tokenId,
            payable(msg.sender),
            payable(address(0)),
            price
        );

        IERC721(nftContract).transferFrom(msg.sender, address(this), tokenId);

        emit MarketItemCreated(
            itemId,
            nftContract,
            tokenId,
            msg.sender,
            address(0),
            price
        );
    }

    //Selling an item on the market
    function createMarketSale(address nftContract, uint256 itemId) public payable nonReentrant{
        uint price = idToMarketItem[itemId].price;
        uint tokenId = idToMarketItem[itemId].tokenId;

        require(msg.value == price, "Please submit the asking price in order to complete the purchase");

        idToMarketItem[itemId].seller.transfer(msg.value);
        //taking value from this addres and sending to message sender
        IERC721(nftContract).transferFrom(address(this), msg.sender, tokenId);
        //Setting owner to msg.sender bc now they own the assets
        idToMarketItem[itemId].owner = payable(msg.sender);
        _itemsSold.increment(); 
        //everytime someone buys something my account fills up with moneyyyy
        payable(owner).transfer(listingPrice);
    }

    //fetches items that are for sale
    function fetchMarketItems() public view returns (MarketItem[] memory) {
        uint itemCount = _itemIds.current();
        uint unsoldItemCount = itemCount - _itemIds.current();
        uint currentIndex = 0;

        MarketItem[] memory items = new MarketItem[](unsoldItemCount);
        //parsing through all items
        //very expensive
        for(uint i = 0; i < itemCount; i++){
            //if there is nothing there in the address, it catches it and puts it in the item array and then returns the array of 
            //items that are not for sale
            if(idToMarketItem[i+1].owner == address(0)){
                uint currentId = idToMarketItem[i+1].itemId;
                MarketItem storage currentItem = idToMarketItem[currentId];
                items[currentIndex] = currentItem;
                currentIndex ++;
            }
        }
        return items;
    }

    //function to return items we have purchased ourselves
    function fetchMyNFTs() public view returns (MarketItem[] memory){
        uint totalItemCount = _itemIds.current();
        uint itemCount = 0;
        uint currentIndex = 0;

        //looping through to catch all items in the array that we own and count them
        for(uint i = 0; i < totalItemCount; i++){
            if(idToMarketItem[i+1].owner == msg.sender){
                itemCount++;
            }
        }

        MarketItem[] memory items = new MarketItem[](itemCount);
        for(uint i = 0; i < itemCount; i++){
            //then goes until the end of the items we own and puts them in an array in which we return
            if(idToMarketItem[i+1].owner == msg.sender){
                uint currentId = idToMarketItem[i+1].itemId;
                MarketItem storage currentItem = idToMarketItem[currentId];
                items[currentIndex] = currentItem;
                currentIndex ++;
            }
        }
        return items;
    }


}
