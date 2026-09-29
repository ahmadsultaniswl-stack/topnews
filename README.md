# Top News 📰 — News Reader App

A full-featured Flutter news reader app — "Top News of the World" — with authentication, categorized news, search, bookmarks, and profile management, consuming a public REST API for real-time articles.

<!--
📸 SCREENSHOT INSTRUCTIONS (delete this comment block once done):
1. Take screenshots (Splash, Sign In, Create Account, Home, Explore, Bookmarks, Settings, Profile).
2. Drag-and-drop images directly into this README while editing it on GitHub, OR
3. Create a folder named "screenshots" and reference them: ![Home](screenshots/home.png)
-->

## 📱 Screenshots

| Splash | Sign In | Create Account |
|--------|---------|-------------------|
| <img width="576" height="1280" alt="WhatsApp Image 2026-09-10 at 1 16 44 AM" src="https://github.com/user-attachments/assets/0e1ef934-f9fe-4c07-8284-22e68f9b33b0" /> | <img width="576" height="1280" alt="WhatsApp Image 2026-09-10 at 1 16 45 AM" src="https://github.com/user-attachments/assets/2dee825d-cae2-4ab5-9c52-e639d1a8b638" /> | <img width="576" height="1280" alt="WhatsApp Image 2026-09-10 at 1 16 47 AM" src="https://github.com/user-attachments/assets/3ffe7bd1-2186-49a0-9935-4fbfd86193e3" /> |

| Home (Categorized News) | Explore | Bookmarks |
|----------------------------|---------|-----------|
| <img width="576" height="1280" alt="WhatsApp Image 2026-09-10 at 1 16 48 AM" src="https://github.com/user-attachments/assets/c2a2bc09-e4c4-48b7-897f-e1bdad11487e" />| <img width="576" height="1280" alt="WhatsApp Image 2026-09-10 at 1 16 48 AM (1)" src="https://github.com/user-attachments/assets/5f349c88-a4c6-46cd-9aaa-f5c8a91fe776" /> | <img width="576" height="1280" alt="WhatsApp Image 2026-09-10 at 1 16 49 AM" src="https://github.com/user-attachments/assets/e8b7a350-efe9-49a5-b6cb-7c43767e1166" /> |

| Settings | Profile / Edit Info | About Us |
|----------|--------------------------|----------|
| <img width="576" height="1280" alt="WhatsApp Image 2026-09-10 at 1 16 49 AM (1)" src="https://github.com/user-attachments/assets/de004f5f-0135-49bf-9759-2a80eab86d0b" /> | <img width="576" height="1280" alt="WhatsApp Image 2026-09-10 at 1 16 51 AM (1)" src="https://github.com/user-attachments/assets/2f1ef904-70f0-402b-a4c5-774b98342694" /> | <img width="576" height="1280" alt="WhatsApp Image 2026-09-10 at 1 16 52 AM (1)" src="https://github.com/user-attachments/assets/41515047-4c12-4e3c-8c62-9f3879673f93" />|

---

## ✨ Features

- 🔐 **Authentication** — Sign In / Create Account, with Google, Instagram, and LinkedIn sign-in options
- 📡 **Real-time news** — consumes a public news REST API for categorized, up-to-date articles
- 🗂️ **Category browsing** — Technology, Business, Sports, Health, Science, Entertainment, and more, via Home and Explore tabs
- 🔖 **Bookmarks** — save articles to read later
- 🔍 **Search** — search any news article
- 🔗 **Social sharing** — share articles via `url_launcher`
- ⚙️ **Settings** — Dark Mode toggle, Change Password, Delete Account
- 👤 **Profile management** — view and edit personal information (name, email)
- 🐞 **Debugged edge cases** — resolved API auth issues and GetX state edge cases during development

---

## 🛠️ Tech Stack

| Category | Technology |
|---|---|
| Framework | Flutter, Dart |
| State Management | GetX |
| Data | REST API |

---

## 🚀 Getting Started

```bash
# Clone the repo
git clone https://github.com/ahmadsultaniswl-stack/topnews.git
cd topnews

# Install dependencies
flutter pub get

# Run the app
flutter run
```

> Note: You may need your own API key for the news API depending on the provider used — check the API service file in `lib/`.

---

## 👤 Author

**Saie Ahmad**
Flutter Mobile App Developer
📧 ahmadsultaniswl@gmail.com
🔗 [LinkedIn](https://www.linkedin.com/in/saie-ahmad)
