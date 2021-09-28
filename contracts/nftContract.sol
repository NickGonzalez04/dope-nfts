// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;


// imports
import '@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol';
import '@openzeppelin/contracts/utils/Counters.sol';
import 'hardhat/console.sol';


// interfaces 
// libraries
import { Base64 } from "./libraries/Base64.sol";

// NFT Contract 
contract DopeNft is ERC721URIStorage {

    // from openzep, helps track tokenID's
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    // base of NFT
    string baseSvg = "<svg width='350' height='350' viewBox='0 0 350 350' fill='none' xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink'><g clip-path='url(#clip0)'><rect width='350' height='350' fill='";

    string baseHead = "<path d='M71.6453 164.441L71.6435 164.434L71.6412 164.426C65.7516 145.344 66.1273 129.055 70.7418 115.353C75.3568 101.65 84.2181 90.5164 95.3308 81.7589C117.563 64.2384 148.783 56.25 172.902 56.25C197.039 56.25 226.7 61.3712 248.759 77.452C270.793 93.5154 285.279 120.541 279.045 164.453C273.305 188.396 253.212 221.23 231.298 248.092C220.343 261.521 208.943 273.446 198.67 282.011C193.533 286.294 188.683 289.732 184.316 292.099C179.944 294.467 176.077 295.75 172.902 295.75C164.592 295.75 154.824 290.551 144.642 281.942C134.469 273.342 123.923 261.374 114.062 247.915C94.3375 220.993 77.3849 188.148 71.6453 164.441Z' stroke='black' stroke-width='0.5' fill='";

    string faceFeature = "<ellipse cx='132.361' cy='165.043' rx='27' ry='37' transform='rotate(-30 132.361 165.043)' fill='black'/><ellipse cx='214.883' cy='165.543' rx='27' ry='37' transform='rotate(30 214.883 165.543)' fill='black'/><circle cx='213' cy='150' r='7' fill='white'/><circle cx='133' cy='150' r='7' fill='white'/><line x1='219.983' y1='218.647' x2='229.064' y2='208.658' stroke='black' stroke-width='0.5' stroke-linecap='round'/><g filter='url(#filter0_d)'><line x1='128.647' y1='222.015' x2='118.695' y2='212.893' stroke='black' stroke-width='0.5' stroke-linecap='round'/></g><ellipse cx='172' cy='206.5' rx='1' ry='4.5' transform='rotate(9 172 206.5)' fill='black'/><ellipse cx='176' cy='206.5' rx='1' ry='4.5' transform='rotate(-9 176 206.5)' fill='black'/><ellipse cx='174' cy='244' rx='27' ry='3' fill='black'/><rect x='125' y='311' width='100' height='32.4675' fill='url(#pattern0)'/></g>";

    string smoker = "<path d='M215.064 264.479C222.189 270.106 228.453 275.435 232.819 279.502C235.002 281.536 236.709 283.252 237.811 284.531C238.363 285.171 238.759 285.696 238.989 286.095C239.104 286.295 239.173 286.456 239.201 286.579C239.23 286.704 239.211 286.765 239.188 286.794C239.165 286.823 239.11 286.856 238.981 286.857C238.855 286.858 238.682 286.828 238.461 286.763C238.021 286.632 237.417 286.368 236.667 285.98C235.167 285.204 233.102 283.942 230.618 282.29C225.649 278.985 219.013 274.128 211.888 268.502C204.762 262.875 198.499 257.546 194.133 253.479C191.949 251.445 190.243 249.729 189.14 248.45C188.588 247.81 188.192 247.285 187.963 246.886C187.848 246.686 187.779 246.525 187.75 246.402C187.722 246.277 187.741 246.216 187.764 246.187C187.787 246.158 187.842 246.125 187.97 246.124C188.097 246.123 188.269 246.153 188.49 246.218C188.931 246.349 189.534 246.613 190.285 247.001C191.784 247.777 193.849 249.039 196.334 250.691C201.302 253.996 207.938 258.853 215.064 264.479Z' fill='white' stroke='black' stroke-width='0.25'/><path d='M235 285.377C236.435 285.054 236.216 284.639 237.056 285.572C237.407 285.962 237.688 286.377 238.25 286.377' stroke='black' stroke-width='3' stroke-linecap='round'/>";

    string hatPiece = "<path d='M171.552 34.2382L171.576 34.2402L171.601 34.2373C201.863 30.6619 220.93 37.2633 232.427 46.5404C243.931 55.8229 247.882 67.8026 247.882 75.031C247.882 78.5804 245.855 81.9961 242.111 85.1356C238.369 88.274 232.94 91.1116 226.208 93.4995C212.748 98.2745 194.136 101.233 173.566 101.233C152.996 101.233 134.384 98.2745 120.923 93.4995C114.192 91.1116 108.762 88.274 105.02 85.1356C101.277 81.9961 99.25 78.5804 99.25 75.031C99.25 67.7683 101.298 56.2723 111.328 47.2439C121.359 38.2154 139.422 31.6098 171.552 34.2382Z' fill='white' stroke='black' stroke-width='0.5'/><path d='M173.579 67.7967L173.587 67.7972L173.595 67.7972C182.731 67.8071 189.441 68.2548 194.368 69.0193C199.298 69.7843 202.422 70.8637 204.402 72.1235C206.369 73.3754 207.21 74.8077 207.57 76.3132C207.859 77.5185 207.843 78.7673 207.826 80.0447C207.822 80.3901 207.817 80.7376 207.818 81.0869C207.824 82.5917 206.93 84.0673 205.219 85.4483C203.51 86.8275 201.019 88.0843 197.916 89.1487C191.714 91.2764 183.123 92.6161 173.616 92.6546C164.109 92.693 155.508 91.4229 149.289 89.3454C146.178 88.3063 143.676 87.0696 141.956 85.7044C140.234 84.3372 139.328 82.8689 139.322 81.3641C139.32 81.077 139.316 80.785 139.311 80.4892C139.264 77.4241 139.21 73.9542 142.824 71.3491C144.821 69.9098 147.956 68.7217 152.88 68.0444C157.801 67.3674 164.491 67.2032 173.579 67.7967Z' fill='black' stroke='black' stroke-width='0.5'/>";

    string spaceHelmet = "<line x1='157.906' y1='311.001' x2='189.891' y2='310.001' stroke='#8F8E8E' stroke-width='6'/><line x1='157.906' y1='317.001' x2='189.891' y2='316.001' stroke='#8F8E8E' stroke-width='6'/><path d='M309.5 166C309.5 245.839 249.249 310.5 175 310.5C100.751 310.5 40.5 245.839 40.5 166C40.5 86.1606 100.751 21.5 175 21.5C249.249 21.5 309.5 86.1606 309.5 166Z' fill='#C4C4C4' fill-opacity='0.34' stroke='black'/>'<ellipse cx='171.5' cy='36.5' rx='9.5' ry='1.5' fill='black'/>'";

    string tongue = "<path d='M186.979 261.983L186.975 262.018V262.053C186.975 271.265 181.233 278.5 174.404 278.5C167.574 278.5 161.833 271.265 161.833 262.053V262.026L161.83 262C161.317 257.16 161.43 253.731 161.977 251.306C162.522 248.893 163.489 247.507 164.671 246.694C165.867 245.872 167.355 245.584 169.046 245.517C169.888 245.483 170.766 245.505 171.668 245.535C171.824 245.541 171.981 245.546 172.139 245.552C172.887 245.579 173.649 245.606 174.404 245.606C175.153 245.606 175.918 245.579 176.673 245.553C176.838 245.547 177.003 245.541 177.167 245.536C178.087 245.505 178.989 245.483 179.859 245.517C181.606 245.584 183.161 245.873 184.401 246.699C185.623 247.512 186.607 248.895 187.119 251.3C187.634 253.719 187.664 257.144 186.979 261.983Z' fill='#F5B0E4' stroke='black'/>";
    
    string antenna = "<path d='M209.329 77.377C209.329 77.377 213 32 247 42.5' stroke='#7CE636' stroke-width='4'/><circle cx='248' cy='43' r='3' fill='#7CE636'/><path d='M140.679 76.7222C140.679 76.7222 137.008 31.3452 103.008 41.8452' stroke='#7CE636' stroke-width='4'/><circle cx='102' cy='42' r='3' fill='#7CE636'/>";

    string baseEnd ="<defs><filter id='filter0_d' x='114.342' y='212.54' width='18.658' height='17.8287' filterUnits='userSpaceOnUse' color-interpolation-filters='sRGB'><feFlood flood-opacity='0' result='BackgroundImageFix'/><feColorMatrix in='SourceAlpha' type='matrix' values='0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 127 0' result='hardAlpha'/><feOffset dy='4'/><feGaussianBlur stdDeviation='2'/><feComposite in2='hardAlpha' operator='out'/><feColorMatrix type='matrix' values='0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0.25 0'/><feBlend mode='normal' in2='BackgroundImageFix' result='effect1_dropShadow'/><feBlend mode='normal' in='SourceGraphic' in2='effect1_dropShadow' result='shape'/></filter>";


    // Alien ID's
    string zero = "<pattern id='pattern0' patternContentUnits='objectBoundingBox' width='1' height='1'><use xlink:href='#image0' transform='scale(0.00980392 0.02)'/></pattern><image id='image0' width='102' height='50' xlink:href='data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAGYAAAAyAQMAAACUDjzAAAAABlBMVEX///8AAABVwtN+AAAACXBIWXMAAA7EAAAOxAGVKw4bAAAASUlEQVQokWP4jwT+MDQwIAAL/XlSTj5+J29a6x2zOjDieCSGWQAKL/Dx8QYE77dZzgFcvOCyt8hy2/Nwq0ThodpAcUyTyUNJrQCGmJubNrbrkgAAAABJRU5ErkJggg=='/>";  
    
    string one = "<pattern id='pattern0' patternContentUnits='objectBoundingBox' width='1' height='1'><use xlink:href='#image0' transform='scale(0.00649351 0.02)'/></pattern><image id='image0' width='154' height='50' xlink:href='data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAJoAAAAyAQMAAACeflDXAAAABlBMVEX///8AAABVwtN+AAAACXBIWXMAAA7EAAAOxAGVKw4bAAAAYElEQVQ4jWP4jwkOMDQwYACHoSPIuMQsTWmjtJGP38mblovMrA6MCtJJkGqxGYAhaF/DEPj4MJogTxrDb7N0bILZmILBZY+xqNyejE07FsFgDEGwk84foMCbg0UQWyEAANia1cwOdep7AAAAAElFTkSuQmCC'/>";

    string two = "<pattern id='pattern0' patternContentUnits='objectBoundingBox' width='1' height='1'><use xlink:href='#image0' transform='scale(0.00649351 0.02)'/></pattern><image id='image0' width='154' height='50' xlink:href='data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAJoAAAAyAQMAAACeflDXAAAABlBMVEX///8AAABVwtN+AAAACXBIWXMAAA7EAAAOxAGVKw4bAAAAYklEQVQ4jWP4jwkOMDQwYACHoSPIuMQsTWmjtJGP38mbc9aUWR0YFaSTINViMwBD0L6GIfDx8QZUQZ40ht9mOQeIEwwue4BF5fZkbGamMWBqN8vB5qTzaGaS5M3BIoitEAAAvfPlSUYSVgYAAAAASUVORK5CYII='/>";

    string three = "<pattern id='pattern0' patternContentUnits='objectBoundingBox' width='1' height='1'><use xlink:href='#image0' transform='scale(0.00649351 0.02)'/></pattern><image id='image0' width='154' height='50' xlink:href='data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAJoAAAAyAQMAAACeflDXAAAABlBMVEX///8AAABVwtN+AAAACXBIWXMAAA7EAAAOxAGVKw4bAAAAXklEQVQ4jWP4jwkOMDQwYACHoSPIuMQsTWmjtJGP38mb083drA6MCtJJkGqxGYAhaF/DEPj4eAOqIE8aw2+znANYBBMwBYPLnmPRvh2LSuzaMSzC6iSSvDlYBLEVAgCwldp/oMy8aAAAAABJRU5ErkJggg=='/>";


    string four = "<pattern id='pattern0' patternContentUnits='objectBoundingBox' width='1' height='1'><use xlink:href='#image0' transform='scale(0.00649351 0.02)'/></pattern><image id='image0' width='154' height='50' xlink:href='data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAJoAAAAyAQMAAACeflDXAAAABlBMVEX///8AAABVwtN+AAAACXBIWXMAAA7EAAAOxAGVKw4bAAAAYUlEQVQ4jWP4jwkOMDQwYACHoSPIuMQsTWmjtJGP38mbk3dcszowKkgnQarFZgCGoH0NQ+DjAwdQBXnSGH6bJWITTMYUDC57hkXl9hxs2vOxaDdLQBPE6iSSvDlYBLEVAgA92+4hldbwiwAAAABJRU5ErkJggg=='/>";

    string five = "<pattern id='pattern0' patternContentUnits='objectBoundingBox' width='1' height='1'><use xlink:href='#image0' transform='scale(0.00649351 0.02)'/></pattern><image id='image0' width='154' height='50' xlink:href='data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAJoAAAAyAQMAAACeflDXAAAABlBMVEX///8AAABVwtN+AAAACXBIWXMAAA7EAAAOxAGVKw4bAAAAZklEQVQ4jWP4jwkOMDQwYACHoSPIuMQsTWmjtJGP38mbOxXTrA6MCtJJkGqxGYAhaF/DEPj4/AFUQZ40ht9mOQxYBPMbMASDy95g0b49AZuZWASDzXLQBMFOOo5mEUneHCyC2AoBAPpd3TMVA/39AAAAAElFTkSuQmCC'/>";

    string six= "<pattern id='pattern0' patternContentUnits='objectBoundingBox' width='1' height='1'><use xlink:href='#image0' transform='scale(0.00649351 0.02)'/></pattern><image id='image0' width='154' height='50' xlink:href='data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAJoAAAAyAQMAAACeflDXAAAABlBMVEX///8AAABVwt+AAAACXBIWXMAAA7EAAAOxAGVKw4bAAAAX0lEQVQ4jWP4jwkOMDQwYACHoSPIuMQsTWmjtJGP38mbcw2mWR0YFaSTINViMwBD0L6GIfDx8QZUQZ40ht9mOQewCTJgCAaXvceifTt27ZiCwRiCWJ1EkjcHiyC2QgAA9EPfeUciOdcAAAAASUVORK5CYII='/>";


    string seven = "<pattern id='pattern0' patternContentUnits='objectBoundingBox' width='1' height='1'><use xlink:href='#image0' transform='scale(0.00649351 0.02)'/></pattern><image id='image0' width='154' height='50' xlink:href='data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAJoAAAAyAQMAAACeflDXAAAABlBMVEX///8AAABVwtN+AAAACXBIWXMAAA7EAAAOxAGVKw4bAAAAY0lEQVQ4jWP4jwkOMDQwYACHoSPIuMQsTWmjtJGP38mbt9erWR0YFaSTINViMwBD0L6GIfDx+QOogjxpDL/NErAJJjZgCAaXPcQU/L09mQGLdiyCwWZp2Jx0jBJvDhZBbIUAALvE4q1Mw0roAAAAAElFTkSuQmCC'/>";

    string eight = "<pattern id='pattern0' patternContentUnits='objectBoundingBox' width='1' height='1'><use xlink:href='#image0' transform='scale(0.00649351 0.02)'/></pattern><image id='image0' width='154' height='50' xlink:href='data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAJoAAAAyAQMAAACeflDXAAAABlBMVEX///8AAABVwtN+AAAACXBIWXMAAA7EAAAOxAGVKw4bAAAAWUlEQVQ4jWP4jwkOMDQwYACHoSPIuMQsTWmjtJGP38mbl223WR0YFaSTINViMwBD0L6GIfDx8QZUQZ40ht9mOQeIEwwue45F+3aitWMIYnUSSd4cLILYCgEAcoPnJ3jLqeoAAAAASUVORK5CYII='/>";

    string nine = "<pattern id='pattern0' patternContentUnits='objectBoundingBox' width='1' height='1'><use xlink:href='#image0' transform='scale(0.00649351 0.02)'/></pattern><image id='image0' width='154' height='50' xlink:href='data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAJoAAAAyAQMAAACeflDXAAAABlBMVEX///8AAABVwtN+AAAACXBIWXMAAA7EAAAOxAGVKw4bAAAAXklEQVQ4jWP4jwkOMDQwYACHoSPIuMQsTWmjtJGP38mbp/W+WR0YFaSTINViMwBD0L6GIfDx8QZUQZ40ht9mOQeIEwwue4NF5fZ0bNoTsGjHMBOrk0jy5mARxFYIAAD03uo9yn23FgAAAABJRU5ErkJggg=='/>";

    // arrays holding string of words that will be used to pick random words for NFT generation
    string[] backgroundColor = ['black','white', '#638596', '#95554f'];
    string[] alienSkinColor = ['#7CE636','#86D4F7','#A19FFB','#9CE491','#EC9FFF','#FFFFFFD' ];
    string[] headPiece = [smoker, hatPiece, spaceHelmet, antenna, tongue];
    string[] idCard = [zero, one, two, three, four, five, six, seven, eight, nine];

    // Alien Full Name
    string[] firstName = ["James", "Bob", "Frank", "Joe", "Alex", "X AE A-Xii", "Bill", "Peter", "Jeffery", "William", "Paul","Kevin", "Ronald", "Mark", "Daniel", "George", "Thomas", "Weezy", "Drake","AAron" ];
    string[] lastName = ["Xander", "Zaden","Crux","Novak","Oxa", "Rickon", "Torion", "Xan", "E.T.", "Zadoc", "Elon", "Bezzos", "Zaki", "Zayit", "Astro", "Cosmo","Link", "Orion", "Farza", "Pavo", "Rickroll"];

    // Alien Galaxy  - **coming soon
    // string[] homePlanet = ["Mustafar", "Genosis", "Polis Massa", "Wobani", "Eadu", "Mygeeto", "D'Qar", "Endor", "Naboo", "Coruscant", "Ahch-To", "Bespin", "Tatooine", "Kashyyyk", "Scarif", "Takodana"];

    constructor() ERC721 ('_Back to the Ether', 'SQAURE') {
    console.log('Inside DopeNFT contract');
    }

    //Picks background color for alien 
    // To do: refactor functions
     function pickRandomColor(uint tokenId) public view returns (string memory) {
         uint256 randPick = random(string(abi.encodePacked('black', Strings.toString(tokenId))));
         randPick = randPick % backgroundColor.length;
         return backgroundColor[randPick];
     }
    function pickSkinColor(uint tokenId) public view returns (string memory) {
        uint256 randPick = random(string(abi.encodePacked('#7CE636', Strings.toString(tokenId))));
        randPick = randPick % alienSkinColor.length;
         return alienSkinColor[randPick];
    }

      function pickHeadFeature(uint tokenId) public view returns (string memory) {
        uint256 randPick = random(string(abi.encodePacked(smoker, Strings.toString(tokenId))));
        randPick = randPick % headPiece.length;
         return headPiece[randPick];
    }

      function idCardSelection(uint tokenId) public view returns (string memory) {
        uint256 randPick = random(string(abi.encodePacked(zero, Strings.toString(tokenId))));
        randPick = randPick % idCard.length;
         return idCard[randPick];
    }

    // random first name 
    function pickfirstName(uint tokenId) public view returns (string memory) {
        uint256 randPick = random(string(abi.encodePacked("James", Strings.toString(tokenId))));
        randPick = randPick % firstName.length;
        return firstName[randPick];
    }

    // random last name
    function picklastName(uint tokenId) public view returns (string memory) {
        uint256 randPick = random(string(abi.encodePacked("Xander", Strings.toString(tokenId))));
        randPick = randPick % lastName.length;
        return lastName[randPick];
    }
    // Taken out until it is ready to put into Metadata
    // function pickhomePlanet(uint tokenId) public view returns (string memory) {
    //     uint256 randPick = random(string(abi.encodePacked("Mustafar", Strings.toString(tokenId))));
    //     randPick = randPick % homePlanet.length;
    //     return homePlanet[randPick];
    // }

    function random(string memory input) internal pure returns (uint256) {
      return uint256(keccak256(abi.encodePacked(input)));
  }


    // function for user to use for minting their NFT
    function constructDopeNft() public {
        // Retrieving tokenId - starts at 0
        uint256 newItemId = _tokenIds.current();

        // functions that run our random pic of our NFT
        string memory background = pickRandomColor(newItemId);
        string memory headColor = pickSkinColor(newItemId);
        string memory headFeature = pickHeadFeature(newItemId);
        string memory idNum = idCardSelection(newItemId);
        
        // functions that return names
        string memory first = pickfirstName(newItemId);
        string memory last = picklastName(newItemId);
        // encode names to reprenst a full generated name
        string memory fullName = string(abi.encodePacked(first," ",last));
        // string memory home = pickhomePlanet(newItemId);

        // returning our randomly picked alien
        string memory selectedAlien = string(abi.encodePacked(background, "'/>", baseHead, headColor,"'/>", faceFeature, headFeature, baseEnd, idNum));
        string memory alienSVG = string(abi.encodePacked(baseSvg, selectedAlien,'</defs></svg>'));

        // JSON metadata
        string memory jsonMeta = Base64.encode(
            bytes(
                string(
                    abi.encodePacked(
                        '{"name": "', 
                        fullName,
                        '", "description": "Back to the Ether", "image": "data:image/svg+xml;base64,',
                        Base64.encode(bytes(alienSVG)),
                        '"}'
                    )
                )
            )
        );

        // we set up metadata to data/application
        string memory tokenUri = string(
            abi.encodePacked("data:application/json;base64,", jsonMeta)
        );
        // test console.log for script/run.js
        console.log("\n--------------------");
        console.log(alienSVG);
        console.log("--------------------\n");
        console.log(tokenUri);
        // function that mints an NFT from msg.sender which is the address of user .. // that is using func.
        _safeMint(msg.sender, newItemId);
        // setting data to new NFT
        // _setTokenURI(newItemId, 'https://jsonkeeper.com/b/C4MV');
        _setTokenURI(newItemId, tokenUri);
        console.log('An NFT w/ ID %s has been minted to %s', newItemId, msg.sender);
        // tokenId is increment when nft is minted 'created'
        _tokenIds.increment();
    }

}


// Contract Structure
    // Type declarations
    // State variables
    // Events
    // Functions