Simple Prototype Description for Planet City Builder
Team members: Jahnu Best
Development: Flutter + Dart + Flame
Platforms: Cross-platform

Current features included:
    Loading screen (hard-coded progress bar)
    Planet selection screen with sliding gesture functionality
    Procedural city-builder generator with basic features
        Three different square-shaped zone types generate based on simple demand variable
        Zones generate buildings based on demand which increase population
        Basic Text UI to describe city

Disparity between Prototype and MVP:
    Little to no user control over city design
        User can manually place zones
        User can manually draw roads
        User can choose from different zone shapes and sizes
        Alternatively, can select from variety of city designs (grid, circle, random, etc.)
    Multiple cities per planet
        Need to store information for each city for each planet
        Meed to load information when planet or city is loaded
        Add dropdown menu (?) from planet select view to access specific city
    Autosave feature
        Need to store all details of city in SharedPreferences
        Every so often, autosave city status
        Load last saved city on planet when loaded
    Basic resource management
        Add budget/expenses panel 
        Each city should generate X specific resources for export (track with variables)
            More extreme planets are more expensive to build/maintain, but over time export more valuable resources
    Sound Effects/Music
        Aid with immersion
        Relatively simple to implement; difficult to assemble

The generic goals of the game are for the player to feel curious to continue finding new planets to habitat and express their creativity through the founding and expansion of different cities.

Value: Immersion into different worlds
    Have different planets with variety of resources (and terrain?) across different cities to incentivize growth and commitment
    Monetary and resource tracking combined with scarcity of resources should help incentivize long-term commitment to a specific game save.
Value: Control over creativity
    Players should be able to design some high-level aspects of their city such as major road paths, important buildings, and the layout of the city.
    Players should be able to choose where to build their city and what resources to mine/export.
    Players should have management over their budget and expenses.
    Bonus: Implement districts with specific rules/budgets for more fine-tuning.
Value: Emphasize difficulty in space exploration and colonization
    The more extreme planets should be more expensive to build cities on and to mine the more valuable resources. (Eventually they should be locked according to a research tree, but not for MVP.)
    Expansion should be slow and expensive to encourage commitment to one city, until it is profitable enough to finance the founding of other cities.

Preferred OS: Android
Preferred language: Kotlin or Dart 
Cross-platform development: No, unless using Flutter.io 
Team collaboration preferred: Neutral 
Project idea: Unknown (likely game-based)

I have prior experience in Android development and no personal access to iOS devices, so Android development will be the primary objective.

Collaboration with another team member with access to iOS devices makes cross-platform development a more likely possibility.

Learning Flutter.io from scratch for the purpose of cross-platform development is also a possibility.

A game-based project is suggested to revive my interest in mobile development.

Project Summary:
"Planet City Builder" is a space-based, procedural city-builder video game where players design and manage cities across unique planets. Harness planetary resources, zone cities, and conquer hostile environments to create a sprawling network of civilizations. Watch your cities grow from humble beginnings into thriving hubs. By combining space exploration and city-building, this game will offer an immersive experience for those seeking strategy and the challenge of simulated, interplanetary expansion.

Value Proposition:
The space exploration and city-building genres are both well-established, so the primary goal of Planet City Builder (PCB) is not to reinvent these genres or attempt to solve perceived shortcomings in past games. Instead, PCB aims to carve out a unique space by addressing unmet demand. It follows a common industry trend where games released in saturated markets succeed by tapping into niche opportunities. PCB seeks to blend space exploration and city-building in a way that hasn’t been perfected before. Many games in these genres tend to become repetitive or overly drawn out after extended play, but PCB is designed to offer a fresh and engaging experience that can captivate players for hundreds of hours across multiple playthroughs. Additionally, PCB emphasizes user-friendly mechanics to ensure that building a vast galactic empire remains accessible and enjoyable from beginning to end.

Primary Purpose:
While the primary purpose of PCB is to provide an entertaining experience, it also seeks to offer something distinct that is not yet available in existing games. A truly complex fusion of the city-building and space-exploration genres remains unexplored by developers. PCB aims to bridge that gap, offering players a deeper understanding of the challenges and costs of living on other planets, while also encouraging them to broaden their perspectives beyond Earth. The game inspires creativity by allowing players to shape their virtual worlds, designing cities based on their own unique visions, locations, and specializations.

Target Audience:
The primary target audience for PCB consists of video game players who have a strong interest in both space exploration and city-building genres. More specifically, it appeals to those who enjoyed competitors’ titles but found them lacking in variety, creative freedom, or interest as time passes (as discussed in the Competitor Analysis). PCB’s primary audience ranges from early teens to adults of all genders. While not part of the core target audience, space enthusiasts and real-world city planners may also find PCB intriguing, even if they don’t typically play video games.

Success Criteria:
The primary goal of PCB is to deliver a positive play experience that captivates players for as many hours as they wish. Success will be measured firstly by the percentage of positive reviews, as this reflects the overall quality of the game. Secondary criteria include the average hours played per player, total sales (though revenue is not the main objective), and the average number of concurrent players, comparable to industry competitors. These metrics are quantifiable and provide a clear benchmark for success (see Competitor Analysis for target figures). The success criteria, in order of importance, are:
1. Percentage of positive reviews
2. Average hours played
3. Total sales
4. Average concurrent players

Competitor Analysis:
This analysis evaluates two games with elements similar to PCB that have achieved success in the gaming industry.

No Man's Sky: A space-exploration survival game with procedural generation.
Sales: Over 10 million as of 2024, with a peak of 200,000 concurrent players.
Strengths:
Its near-infinite sci-fi universe offers endless discovery, whereas PCB will focus on real-world planets in a much smaller universe.
Emphasizes personal discovery and creation, fostering a unique player identity, while PCB offers a more "overlord" style of control.
Weaknesses:
Despite its vast universe, No Man’s Sky has limited variation in planets and wildlife, leading to eventual fatigue. PCB’s hand-crafted planets will sustain long-term engagement.
The overwhelming scale and numerous choices in No Man’s Sky may deter some players. PCB will gradually introduce players to complex mechanics, easing them into strategic decision-making.

Dyson Sphere Program: A factory-building space exploration game.
Sales: Over 200,000 in its first week, with an "Overwhelmingly Positive" rating on Steam (over 74,000 reviews).
Strengths:
Offers extensive freedom in factory and resource management, whereas PCB's focus is broader, with less micromanagement.
Diverse resource and factory elements make for rich gameplay, which PCB’s MVP may not yet match.
Weaknesses:
Achieving "perfection" in Dyson Sphere Program can take hundreds of hours. PCB allows flexibility, letting players focus on single cities or expand across multiple solar systems.
Dyson Sphere Program’s lack of procedural elements requires meticulous handcrafting. PCB simplifies this by letting players concentrate on zoning and high-level design, streamlining the process.

Monetization Model: 
PCB will likely launch as a free closed-beta to build audience awareness and address major issues. Following the beta, the game will be available as a one-time purchase with lifetime updates included, aligning with the standard model for similar games in this genre.

Initial Design:
The development timeframe for Planet City Builder's (PCB) MVP is approximately 2-3 months. The initial scope will focus on a single planet to streamline the design and resource management processes. The primary goal is to allow players to design cities that procedurally develop and expand based on player-inputted zoning. Key features for the MVP will include:

A detailed 3D model of a planet with corresponding 2D image textures
Basic resource management (such as money)
A procedural algorithm to handle districting, building placement, roads, and population growth
A map-based view for zoning city layouts
Algorithms to manage edge cases, such as extreme population surges or bankruptcy
A basic UI displaying planetary status and resource metrics

This simplified approach ensures core mechanics are functional while setting a strong foundation for future iterations.

UI/UX Design:
Planet City Builder (PCB) must provide, at a minimum, a visual representation of a planet from space, highlighting the locations of cities. Players should be able to zoom in on a planet’s surface to view their cities in greater detail. For the MVP, this will likely involve two distinct screens with the different viewpoints. The distant view will feature text UI elements displaying the planet’s name and major cities, along with numerical indicators reflecting the overall planetary status (such as population, income, expenses, and bank balance). The close-up view will focus on a specific city, adjusting the displayed numerical values. Other metrics may be included, such as average health and the import/export status of specific resources. Additionally, a dedicated screen for city design must be included, which can either be integrated into the close-up view or presented separately. This approach ensures a straightforward user experience while effectively enabling gameplay.

Technical Implementation:
Since the mobile version of PCB will be ported from Unreal Engine 5, the primary challenge in developing the MVP for mobile will be optimizing resources, algorithms, and assets to ensure smooth performance on less powerful devices. PCB is designed to be played offline, which may necessitate an autosave feature, though this may not be included in the MVP. Future cloud-based features or online integrations are beyond the scope of the MVP. The key technical challenges will be on efficiently adapting the game for mobile platforms, rather than the more typical mobile development challenges (choosing a view model pattern, or Kotlin vs. Java).

Challenges and Open Questions
The overarching technical challenge will be my ability to acquire the necessary skills to complete the MVP in Unreal Engine 5 and successfully port the game to at least one mobile platform by the final presentation deadline. While a poorly performing game is better than no game at all, it would still be a substantial issue. Thus, the primary challenge lies in balancing on-the-job learning with the creation of a playable and enjoyable product that minimizes lag.

More specific challenges include understanding relevant procedural algorithms, mastering techniques for optimizing assets for mobile devices, and adapting to node-based programming after experience with Python and Godot. Although addressing these issues will require time and support, the question remains: will PCB be fun to play even in its MVP form? Prioritizing the rapid development of a functional prototype is crucial to maximizing the game's chances of success while effectively tackling the aforementioned challenges.