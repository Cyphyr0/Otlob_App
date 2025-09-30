# PROJECT BRIEF: OTLOB (UPDATED 2025)

### **Section 1: Executive Summary**

Otlob is a premium, Flutter-based mobile application designed to be the digital champion for Egypt's vibrant and authentic local food scene. It directly addresses the "choice paralysis" and lack of trusted, authentic options faced by "Urban Explorers" by providing a curated, community-driven platform for discovering local culinary heroes. 

Built with **modern 2025 Flutter technology**, Otlob leverages a **clean architecture** with **Riverpod for state management**, **Drift (SQLite) for local storage**, and a **Firebase-first approach** for immediate development, with a seamless transition path to a **.NET/MySQL backend**. Otlob's key value proposition is to act as a trusted guide, connecting users to genuine food experiences through unique features like the 'Tawseya' recommendation system, fostering a community that celebrates and supports local restaurants.

---
### **Section 2: Problem Statement**

Today's urban food delivery landscape in Egypt, while offering convenience, presents a significant and dual-sided problem for both discerning consumers and local businesses.

**For the User ("Sara, the Urban Explorer"):**
*   **Choice Paralysis & Inauthenticity:** Users are inundated with an overwhelming number of options, dominated by large, international chains. This makes the discovery of high-quality, authentic local food a time-consuming and frustrating task.
*   **Erosion of Trust:** Existing platforms are plagued by a proliferation of fake reviews and paid promotions, making it difficult for users to trust the recommendations they see. They crave genuine, community-vetted endorsements.

**For the Local Restaurant:**
*   **Lack of Visibility:** Small, family-run "hidden gems" with superior food quality struggle to compete for visibility against the massive marketing budgets of global chains, hindering their growth potential.
*   **Unfair Reputation Damage:** Generic rating systems that combine feedback for food and delivery mean a restaurant's hard-earned reputation can be unfairly tarnished by a poor delivery experience that is outside of their control.

Existing solutions fall short because they are designed as advertising platforms, not as genuine discovery tools. Their business models incentivize a noisy, pay-to-play environment that prioritizes sponsored listings over quality, failing to serve the user's desire for authenticity or the local restaurant's need for a level playing field.

---
### **Section 3: Proposed Solution**

Otlob is a premium mobile application that provides a trusted, curated, and delightful guide to Egypt's authentic local food scene. It functions as a "personal food concierge," moving beyond a simple utility to actively help users discover and champion local culinary heroes.

Our core approach is to build a trusted ecosystem by focusing on quality and community over paid promotions. This is achieved through several key differentiators:

*   **The 'Tawseya' (Recommendation) System:** Our cornerstone feature, where each user has a single, powerful 'Tawseya' to award per month. This scarcity transforms a simple 'like' into a trusted, meaningful endorsement, creating a powerful signal of quality that cuts through the noise of fake reviews.
*   **A Proactive Discovery Engine:** Instead of passive lists, Otlob actively guides users with curated carousels like 'Hidden Gems' and a 'Surprise Me!' feature, making the discovery process both effortless and exciting.
*   **Fair and Transparent Feedback:** By implementing a dual-rating system, we separate the food and delivery experiences. This protects restaurants from unfair reputational damage and gives users a more accurate and transparent feedback mechanism.
*   **A Premium, Trustworthy Experience:** From the smooth, responsive performance of the Flutter application to professional, downloadable receipts, every detail is designed to feel polished, legitimate, and trustworthy.

**Technical Approach:**
*   **Modern Architecture:** Built with **Flutter 3.35.0+** and **Dart 3.9.2+**, ensuring compatibility with the latest platform features.
*   **State Management:** **Riverpod 2.5.1** provides a clean, reactive, and type-safe approach to state management.
*   **Local Storage:** **Drift 2.28.1** with SQLite ensures fast, reliable offline functionality and data persistence.
*   **Backend Strategy:** **Firebase-first approach** for immediate development, with a seamless transition path to **.NET/MySQL backend** when ready.
*   **Clean Architecture:** Repository pattern with abstracted data sources ensures easy backend transition and maintainable code.

Otlob will succeed where others have failed because it is not trying to be another advertising platform. It is a product with a strong point of view, built on the belief that by aligning the needs of users seeking authenticity with the needs of great local restaurants seeking visibility, we can create a loyal community and become the definitive platform for genuine food discovery in Egypt.

---
### **Section 4: Target Users**

### Primary User Segment: "Sara, the Urban Explorer"

**Profile:**
Sara is a 28-year-old, tech-savvy professional living and working in a bustling Egyptian city like Cairo. She is well-educated, has disposable income, and values authentic experiences over mass-market options.

**Behaviors & Workflows:**
*   She regularly uses food delivery apps for convenience but finds the experience uninspiring and repetitive.
*   She actively seeks out new and interesting experiences, including food, but is time-poor and cannot dedicate hours to researching hidden gems.
*   She often experiences "choice paralysis" from the sheer volume of generic options and is skeptical of the recommendations provided by existing apps.

**Needs & Pain Points:**
*   **Need for Trust:** Sara needs a reliable and trustworthy source for food recommendations, free from the influence of paid ads and manipulated reviews.
*   **Desire for Authenticity:** She craves genuine, local culinary experiences and is tired of the homogenized offerings of large international chains.
*   **Frictionless Discovery:** She needs a quick and delightful way to discover new places that align with her taste for authenticity and quality.
*   **Supporting Local:** She loves the idea of supporting local businesses but lacks an effective tool to do so.

**Goals:**
*   To feel like a knowledgeable insider who knows the city's best-kept culinary secrets.
*   To enjoy a variety of high-quality, authentic local meals without a frustrating search process.
*   To build a connection with her community by directly supporting local restaurant "heroes".
*   To have a beautiful, reliable, and premium tool that makes ordering food a delightful experience.

---
### **Section 5: Goals & Success Metrics**

### Business Objectives
*   **Project Completion:** Successfully deliver a feature-complete, polished, and fully functional "Version 1.0" of the Otlob Flutter app to meet all university graduation project requirements by **[Target Date]**.
*   **User Adoption & Feedback:** Achieve adoption from a target group of **[e.g., 50-100]** initial users during a testing phase, gathering qualitative feedback to validate the product vision.
*   **Demonstrate Product Excellence:** Create a standout project that demonstrates a deep understanding of modern Flutter development principles, from user-centric design to solving a well-defined, real-world problem.

### User Success Metrics
*   **Successful Discovery:** A high percentage of users place an order from a restaurant discovered through a curated carousel ('Hidden Gems') or the 'Surprise Me!' feature, indicating they are finding new places they love.
*   **Trust in Community:** The 'Tawseya' system is actively used, with a majority of active users casting their monthly vote, showing they find value and trust in the community endorsement model.
*   **Reduced Friction:** Users can navigate from opening the app to placing an order in a short amount of time, with a low cart abandonment rate, indicating a smooth and intuitive user journey.
*   **Feeling of Delight:** Qualitative feedback from users specifically mentions the app feeling "premium," "trustworthy," or "delightful," and highlights appreciation for "wow" features like the styled, downloadable receipts.

### Key Performance Indicators (KPIs)
*   **Engagement:**
    *   Monthly Active Users (MAU)
    *   'Tawseya' votes cast / MAU (Target: >70%)
    *   Feature Adoption Rate (% of users using 'Favorites', 'Reorder', 'Surprise Me!')
*   **Retention:**
    *   Day 1, Day 7, and Day 30 user retention rates.
    *   Churn Rate.
*   **Platform Health:**
    *   Conversion Rate (Users who place an order / Users who open the app).
    *   Ratio of orders from discovered restaurants vs. searched restaurants.
*   **Technical Performance:**
    *   Crash-Free Users Rate (Target: >99.5%).
    *   UI Performance (maintaining a smooth 60fps).

---
### **Section 6: MVP Scope**

### **Core Features (Must-Haves for V1.0)**

**1. Core User Journey (The Foundational "Must-Haves")**
*   **Onboarding:** Social & Email Sign-up/Login.
*   **Location Services:** Automatic GPS detection & manual address input.
*   **Core Discovery:** Home screen list, search (restaurant/dish), and basic filtering.
*   **Restaurant Info:** Profile page with essential info, menu, and reviews.
*   **Menu Interaction:** Interactive menu with categories and item details.
*   **Ordering:** "Add to Cart" functionality with a text box for special instructions.
*   **Checkout:** A seamless flow including shopping cart, address confirmation, and payment selection (COD, Digital).
*   **Order Status:** Live order tracking screen.
*   **Basic Account:** User profile management for name and saved addresses.

**2. Engagement & Retention Loop**
*   **Order History:** A detailed list of all past orders.
*   **One-Tap Reorder:** A convenient button to quickly reorder a past meal.
*   **Favorites List:** A dedicated section in the user's profile for saved dishes.
*   **Dual-Rating System:** Separate ratings for the food and the delivery experience.
*   **Push Notifications:** For critical order status changes.

**3. Proactive Discovery Engine (The "Secret Sauce")**
*   **Home Screen Carousels:** Curated collections like 'Hidden Gems' and 'Local Heroes'.
*   **"Surprise Me!" Button:** A fun, single-recommendation feature for quick discovery.
*   **'Tawseya' (Recommendation) System:** The core community upvote feature (one per user, per month).

**4. Polishing & "Wow" Factors**
*   **Shareable Items:** The ability to share a link to a specific menu item with friends.
*   **Styled Digital Receipt:** A professional and visually appealing receipt upon confirmation and in order history.
*   **Downloadable Receipts:** The ability to save receipts as a PDF or Image file.

### **Out of Scope for V1.0**
To ensure we can deliver a polished and focused V1.0, the following capabilities are explicitly out of scope for the customer-facing Flutter application:
*   **Restaurant-Facing Portal:** All restaurant management features are handled by your teammate's separate .NET web portal.
*   **Delivery Driver Application:** A separate application for delivery personnel.
*   **Advanced Social Features:** User-to-user following, activity feeds, or public user profiles.
*   **Group Ordering:** Functionality for group carts or bill splitting.
*   **In-App Chat:** Real-time chat between the user and the restaurant or delivery driver.
*   **Dine-in Features:** Any features related to booking tables or dine-in experiences.

### **MVP Success Criteria**
The V1.0 MVP will be considered a success when:
1.  A user can successfully and smoothly complete the entire core journey, from onboarding to receiving a delivered order.
2.  All "Secret Sauce" and "Wow Factor" features are implemented and functional, clearly demonstrating Otlob's unique value proposition.
3.  The application is stable, responsive, and visually polished, meeting the high-quality standard of a premium application and a final graduation project.
4.  The Flutter app is fully integrated with the .NET backend API, with all data being consumed and displayed correctly.

---
### **Section 7: Post-MVP Vision**

While V1.0 is focused on delivering a polished core experience, this vision outlines the potential for future growth, ensuring our architecture and design can accommodate long-term ambitions.

### **Phase 2 Features**
Once the V1.0 MVP is successfully launched and validated, the next logical phase of development would focus on deepening community engagement and expanding the service's utility. Priority features would likely include:
*   **Advanced Social Features:** Building on the 'Tawseya' system by introducing user profiles, the ability to follow friends or trusted food critics, and see a feed of their activity.
*   **Group Ordering:** Introducing functionality for group carts and seamless bill splitting to make Otlob the go-to app for social meals with friends and colleagues.
*   **In-App Chat:** Facilitating direct, real-time communication between the user and the restaurant for order clarifications.
*   **Dine-in & Reservations:** Expanding beyond delivery to allow users to discover and book tables at their favorite local spots.

### **Long-term Vision (1-2 Years)**
The long-term vision is to solidify Otlob's position as the essential digital companion for food lovers in Egypt. This includes:
*   **Hyper-Personalization:** Leveraging user data and preferences to provide highly personalized discovery and recommendations.
*   **Celebrating Culinary Stories:** Launching a content platform within the app (articles, videos) that tells the stories behind the local chefs and restaurants we champion.
*   **Community Champion Program:** Creating an incentive and reward program for our most active and trusted community members.

### **Expansion Opportunities**
Looking even further ahead, Otlob could explore several exciting expansion vectors:
*   **Beyond Restaurants:** Expanding the platform to include other local artisanal food producers, such as specialty bakers, cheese makers, or local farms.
*   **Otlob Experiences:** Curating and offering unique, bookable food experiences like food tours, cooking classes with local chefs, or tasting events.
*   **Geographic Expansion:** Taking the successful Otlob model to other countries in the region with rich, under-represented local food scenes.

---
### **Section 8: Technical Considerations**

### **Platform Requirements**
*   **Target Platforms:** iOS and Android mobile devices.
*   **OS Support:** The application should target modern versions of iOS (e.g., 14 and above) and Android (e.g., 8.0 / Oreo and above) to leverage current platform capabilities while maintaining broad reach.
*   **Performance Requirements:** A core requirement is to deliver a smooth, premium user experience. This translates to maintaining a consistent 60fps during all animations and scrolling, and ensuring a fast application startup time.

### **Technology Stack (2025)**
*   **Frontend:** The customer-facing mobile application is built exclusively with **Flutter 3.35.0+**.
*   **State Management:** **Riverpod 2.5.1** provides a clean, reactive, and type-safe approach to state management.
*   **Local Storage:** **Drift 2.28.1** with SQLite ensures fast, reliable offline functionality and data persistence.
*   **Networking:** **Retrofit 4.7.1** and **Dio 5.9.0** provide type-safe HTTP client functionality.
*   **Navigation:** **Go Router 16.2.4** enables declarative routing with deep linking support.
*   **Backend Strategy:** 
    - **Phase 1:** **Firebase** (Firebase Core 4.1.1, Auth 6.1.0, Firestore 6.0.2, Storage 13.0.2) for immediate development.
    - **Phase 2:** **.NET/MySQL backend** when ready, with seamless transition via repository pattern.
*   **Database & Hosting:** The choice of database and hosting infrastructure will be managed by the backend team (MySQL).

### **Architecture Considerations**
*   **Clean Architecture:** The project follows a clean architecture pattern with clear separation of concerns:
  - **Presentation Layer:** UI components, pages, and state management with Riverpod.
  - **Application Layer:** Use cases, services, and business logic.
  - **Data Layer:** Repository pattern with abstracted data sources (Firebase/.NET).
*   **Repository Pattern:** Abstracted repositories enable seamless backend transition:
  ```dart
  abstract class RestaurantRepositoryInterface {
    Future<List<RestaurantModel>> getRestaurants();
    Future<RestaurantModel> getRestaurant(String id);
    // ... other methods
  }
  
  class FirebaseRestaurantRepository implements RestaurantRepositoryInterface { ... }
  class DotnetRestaurantRepository implements RestaurantRepositoryInterface { ... }
  ```
*   **API Integration:** All communication and data transfer between the Flutter app and the backend occurs via a well-defined REST API provided by the backend team. The Flutter app does not have direct access to the database.
*   **Offline Support:** Drift with SQLite provides robust offline functionality, ensuring the app works seamlessly even with poor internet connectivity.
*   **Third-Party Integrations:** The app requires integration with a digital payment gateway (Paymob 1.0.5) for online payments.
*   **Security:** Secure handling of user data and authentication tokens (JWT) is paramount. All API communication must be encrypted via HTTPS.

---
### **Section 9: Constraints & Assumptions**

### **Constraints**
*   **Budget:** As a university project, the development budget is effectively zero. This constrains us to using free, open-source technologies and services with generous free tiers.
*   **Timeline:** The project is strictly time-bound by the university's graduation project deadline of **[Graduation Project Deadline]**.
*   **Resources:** The development team consists of two students: one dedicated to the Flutter front-end and one dedicated to the .NET back-end and restaurant portal.
*   **Technical Dependency:** The Flutter application is entirely dependent on the API provided by the back-end team. The functionality and timeline of the front-end are directly tied to the availability and stability of this API.

### **Key Assumptions**
*   **API Availability & Stability:** We assume the back-end team will deliver a stable, well-documented, and performant API in a timely manner that aligns with front-end development milestones.
*   **Achievable Scope:** We assume the defined V1.0 feature set is realistic and achievable for the two-person team within the academic timeline.
*   **User Need Validation:** We assume that the core problem statement is accurate and that users like "Sara" will find significant value in a platform that champions authentic, local food.
*   **Restaurant Willingness:** For the purpose of the project's concept, we assume that high-quality local restaurants would be willing to partner with Otlob if it were a commercial product.
*   **Third-Party Access:** We assume that essential third-party services (e.g., payment gateways, map providers) offer sandbox environments or free tiers that are sufficient for development and demonstration purposes.
*   **Technology Stability:** We assume that the selected technology stack (Flutter, Riverpod, Drift) is stable and suitable for production use.

---
### **Section 10: Risks & Open Questions**

### **Key Risks**
*   **API Dependency & Integration:** The single greatest risk to the project. Delays, bugs, or documentation gaps in the backend API will directly block Flutter development and could jeopardize the project timeline.
*   **Scope Creep:** The V1.0 feature set is ambitious. There is a risk of new ideas or unforeseen complexities emerging during development, which could expand the scope and threaten the deadline.
*   **Team Coordination:** As a two-person team working on highly dependent components, any friction in communication or workflow could lead to significant integration challenges.
*   **Implementation Complexity:** Certain "wow factor" features, such as the on-device generation of styled, downloadable PDF receipts, may prove more technically complex and time-consuming than initially estimated.
*   **Technology Risk:** While the selected technology stack is modern and well-supported, there is always a risk of compatibility issues or unexpected limitations.

### **Open Questions**
*   What is the detailed delivery schedule for each API endpoint from the backend team?
*   What is the agreed-upon strategy for API versioning and error handling?
*   For the V1.0 prototype, how will we source the high-quality, visually rich photography needed to fulfill the app's aesthetic vision?
*   What are the precise technical requirements and limitations of the Paymob sandbox environment?
*   What is the backend logic for managing the 'Tawseya' system (e.g., monthly reset, vote tracking)?
*   How will we handle data synchronization between Firebase and the .NET backend during the transition phase?

### **Areas Needing Further Research**
*   A technical spike to determine the most robust and performant Flutter library for generating, styling, and downloading PDF/Image receipts.
*   An evaluation of the optimal state management approach (Riverpod has been selected, but further validation is needed).
*   A thorough review of the official Paymob integration documentation and SDK to map out the implementation plan.
*   Research into the best practices for transitioning from Firebase to a .NET backend with minimal disruption.

---
### **Section 11: Appendices**

### **A. Research Summary**
No formal market research or competitive analysis was conducted for this initial Project Brief. The project is founded on direct user insight and a clear product vision provided by the primary stakeholder.

### **B. Technology Stack Summary**
*   **Flutter:** 3.35.0+ (Latest stable version)
*   **Dart:** 3.9.2+ (Latest stable version)
*   **State Management:** Riverpod 2.5.1
*   **Local Database:** Drift 2.28.1 (SQLite)
*   **Networking:** Retrofit 4.7.1, Dio 5.9.0
*   **Navigation:** Go Router 16.2.4
*   **Backend (Phase 1):** Firebase (Core 4.1.1, Auth 6.1.0, Firestore 6.0.2, Storage 13.0.2)
*   **Backend (Phase 2):** .NET with MySQL
*   **Payment:** Paymob 1.0.5
*   **Essential Packages:** connectivity_plus 7.0.0, permission_handler 12.0.1, image_picker 1.2.0, device_info_plus 12.1.0, app_links 6.4.1

### **C. Stakeholder Input**
This Project Brief was created in direct collaboration with the primary project stakeholder and Flutter developer. The core vision, user persona, detailed feature set, and technology stack decisions were provided by the primary stakeholder and serve as the foundational source of truth for this document.

### **D. References**
*   **Project Vision & Persona:** The initial detailed prompt outlining the overarching vision, the "Sara, the Urban Explorer" persona, and the desired user experience.
*   **V1.0 Feature Set:** The categorized feature list provided in the project documentation.
*   **Technology Stack:** The current pubspec.yaml with all selected dependencies and versions.

---
### **Section 12: Next Steps**

### **Immediate Actions**
1.  **Finalize Project Brief:** This updated Project Brief serves as our foundational guide for development.
2.  **Set Up Development Environment:** Initialize the Flutter project with the selected technology stack.
3.  **Implement Core Architecture:** Set up the clean architecture with repository pattern and state management.
4.  **Begin Feature Development:** Start implementing core features, beginning with authentication and user onboarding.
5.  **Coordinate with Backend Team:** Establish clear communication channels and API delivery schedule with the .NET backend developer.

### **Development Roadmap**
1.  **Phase 1 (Weeks 1-2):** Project setup, core architecture, and Firebase integration.
2.  **Phase 2 (Weeks 3-5):** Authentication, user management, and restaurant discovery features.
3.  **Phase 3 (Weeks 6-8):** Cart, checkout, and order management features.
4.  **Phase 4 (Weeks 9-10):** 'Tawseya' system and polishing.
5.  **Phase 5 (Weeks 11-12):** Testing, bug fixing, and preparation for backend transition.

### **Backend Transition Planning**
1.  **Define API Contract:** Work with the .NET backend developer to define a clear API contract.
2.  **Implement .NET Repositories:** Create repository implementations for the .NET backend.
3.  **Transition Strategy:** Plan a smooth transition strategy with minimal disruption to users.
4.  **Testing:** Thoroughly test the integration between Flutter app and .NET backend.

With this updated Project Brief, we have a clear vision and technical foundation for building Otlob as a modern, premium food delivery application for Egypt's authentic local food scene.
