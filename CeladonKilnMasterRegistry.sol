// SPDX-License-Identifier: MIT
pragma solidity 0.8.31;

contract CeladonKilnMasterRegistry {

    struct KilnStyle {
        string region;              // Zhejiang, Henan, Shaanxi, Hebei, etc.
        string kilnOrLineage;       // real kiln site, lineage, or workshop
        string styleName;           // Longquan, Yue, Ru, Jun, Yaozhou, Ding
        string claySource;          // local clay type
        string glazeChemistry;      // iron content, reduction firing, celadon formula
        string firingTechnique;     // kiln type, temperature, reduction/oxidation
        string uniqueness;          // what makes this kiln school culturally distinct
        address creator;
        uint256 likes;
        uint256 dislikes;
        uint256 createdAt;
    }

    struct StyleInput {
        string region;
        string kilnOrLineage;
        string styleName;
        string claySource;
        string glazeChemistry;
        string firingTechnique;
        string uniqueness;
    }

    KilnStyle[] public styles;

    mapping(uint256 => mapping(address => bool)) public hasVoted;

    event StyleRecorded(
        uint256 indexed id,
        string styleName,
        string kilnOrLineage,
        address indexed creator
    );

    event StyleVoted(
        uint256 indexed id,
        bool like,
        uint256 likes,
        uint256 dislikes
    );

    constructor() {
        styles.push(
            KilnStyle({
                region: "China",
                kilnOrLineage: "ExampleKiln",
                styleName: "Example Style (replace with real entries)",
                claySource: "example clay",
                glazeChemistry: "example glaze",
                firingTechnique: "example firing",
                uniqueness: "example uniqueness",
                creator: address(0),
                likes: 0,
                dislikes: 0,
                createdAt: block.timestamp
            })
        );
    }

    function recordStyle(StyleInput calldata s) external {
        styles.push(
            KilnStyle({
                region: s.region,
                kilnOrLineage: s.kilnOrLineage,
                styleName: s.styleName,
                claySource: s.claySource,
                glazeChemistry: s.glazeChemistry,
                firingTechnique: s.firingTechnique,
                uniqueness: s.uniqueness,
                creator: msg.sender,
                likes: 0,
                dislikes: 0,
                createdAt: block.timestamp
            })
        );

        emit StyleRecorded(
            styles.length - 1,
            s.styleName,
            s.kilnOrLineage,
            msg.sender
        );
    }

    function voteStyle(uint256 id, bool like) external {
        require(id < styles.length, "Invalid ID");
        require(!hasVoted[id][msg.sender], "Already voted");

        hasVoted[id][msg.sender] = true;

        KilnStyle storage k = styles[id];

        if (like) {
            k.likes += 1;
        } else {
            k.dislikes += 1;
        }

        emit StyleVoted(id, like, k.likes, k.dislikes);
    }

    function totalStyles() external view returns (uint256) {
        return styles.length;
    }
}
