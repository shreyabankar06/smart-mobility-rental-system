# Smart Mobility — Java backend + demo GPS map

Requires **JDK 17 or newer** (a full JDK, not just a JRE). No Python, Maven, database installation or API key is required to run this version.

## Run on Mac / Windows

1. Extract this ZIP.
2. Open Terminal inside the `smart-mobility` folder.
3. Check your Java installation with `java -version`.
4. Run:

```bash
java SmartMobility.java
```

5. Open **http://localhost:8000** in your browser.
6. Leave Terminal open. Press Ctrl+C to stop.

If Java is missing or reports that a compiler is unavailable, install a full JDK 17 or newer from https://adoptium.net/temurin/releases/ and reopen Terminal.

Stop your previous Python server before starting Java because both use port 8000.

## Features

- 25 vehicles with product photos and ascending daily rental prices.
- Account signup/login/logout with PBKDF2 password hashing and expiring HttpOnly sessions.
- Saved bookings, server-computed pricing, date overlap and stock checks.
- Cancellation, simulated payments and simulated unlock during booking dates.
- Shared ride publishing, search and seat reservations.
- Interactive Leaflet street map with three car markers, popups, zoom, pan and selection buttons.
- GPS coordinates supplied by the Java `/api/tracking` endpoint. Refresh and Check Demo Location retrieve the latest demo snapshot.

## Three demo cars

| Vehicle | Demo location | Latitude | Longitude |
|---|---|---|---|
| Tata Nexon EV | Thane Station area | 19.18600 | 72.97500 |
| Honda City | Mulund area | 19.17200 | 72.95600 |
| Maruti Swift | Powai area | 19.11900 | 72.90600 |

Coordinates are illustrative, stationary positions. Refresh updates the response timestamp; it does not claim that the cars moved. This is a working street map of simulated GPS data, not a real vehicle tracker. Real GPS requires a connected device and authorised telemetry integration.

Map tiles, Leaflet, vehicle photos, fonts and icons require internet. If Leaflet fails to load, selection switches to an OpenStreetMap embedded view for the selected car. If tiles cannot load, a message appears and coordinates remain available. Leaflet 1.9.4: https://leafletjs.com/reference.html ; map data: https://www.openstreetmap.org/copyright .

## Storage and existing data

Java automatically creates `mobility-data.json` beside SmartMobility.java. Keep it when updating to retain accounts, bookings and shared rides. Keep it private: it contains account data, password hashes and sessions. Writes are serialised and use a temporary file plus replacement.

This Java version starts with fresh accounts. The old Python `mobility.db` is **not automatically imported** and must not be deleted if you want to keep those earlier records. The ZIP contains no test users or bookings.

## Files

- SmartMobility.java: Java API server, persistence and JSON codec.
- index.html: frontend and interactive map.
- vehicles.json: fleet and illustrative rental prices.
- start.sh / start.bat: convenience launchers.
- PHOTO_CREDITS.md: vehicle image sources.

The Java source-file launcher compiles in memory and runs the application. Run it from the project folder so the frontend and fleet files are found.

## API endpoints

GET /api/health, /api/vehicles, /api/tracking, /api/me, /api/bookings, /api/rides

POST /api/signup, /api/login, /api/logout, /api/bookings, /api/rides

POST /api/bookings/{id}/cancel, /simulate-payment, /unlock, /security

POST /api/rides/{id}/join

## Prototype limitations

Payments and physical unlocking are simulations. Favourites remain visual only. Fleet search passes dates and locations into the booking form; availability is checked at reservation time. Sustainability figures are illustrative. This localhost server is intended for college demonstrations; public hosting requires HTTPS, Secure cookies, rate limiting, a production database and production web server.

Shared rides appear automatically. Optional filters support partial location names. Show All Rides clears filters and refreshes. Browsing is public; offering and reserving require login.
When upgrading, stop the server and copy mobility-data.json from the old project folder into the new one to retain accounts and rides.

Favorites: log in and select vehicle heart buttons. Favorites are saved per account and shown in the Favorites tab beside Electric.
Drivers can delete their offered rides after confirmation; deletion also cancels reserved seats. Other users cannot delete that ride.

ADMIN PORTAL
Open http://localhost:8000/admin. Admin can view counts and all bookings, update vehicle prices/stock, cancel bookings, manage customer account access, and remove shared rides. Favorites, scooter labels and user ride deletion remain included.
First setup on Mac: stop the old server, then run bash start-admin.sh in this folder. Enter a new admin email and a password with at least 12 characters. The password is hidden while typing. Do not reuse an existing customer email. Open /admin and log in with these credentials.
First setup in Windows PowerShell:
$env:ADMIN_EMAIL="your-admin-email@example.com"
$adminSecret=Read-Host "Admin password (12+ characters)" -AsSecureString
$env:ADMIN_PASSWORD=[System.Net.NetworkCredential]::new("",$adminSecret).Password
java SmartMobility.java
After setup the account persists in mobility-data.json. Future starts can use the usual java SmartMobility.java command. Existing admin passwords are not overwritten by startup variables.
When upgrading: stop the server and copy your old mobility-data.json into this folder before starting, to preserve users, rides and bookings. No default credentials or sample customer records are included.
Vehicle changes persist in mobility-data.json and apply after a customer refreshes. Existing booking totals stay as originally booked. Admin cancellations do not issue real refunds; payment remains simulated. This is a local college prototype.

Both portals now appear in the same browser tab at http://localhost:8000. Use User Portal / Admin Portal buttons at the top. The admin view is embedded within the website. Both views have separate login sessions. Admin login does not replace the user account, and logging out of either portal preserves the other login. Customer accounts cannot access admin controls.

UPDATED BOOKING FLOW
New booking -> Pending -> Admin clicks Accept -> Confirmed -> user can simulate payment. The backend rejects payment before confirmation. Existing paid bookings retain their payment record; an admin may still confirm pending legacy bookings. Cancellations cannot be accepted or paid.
SHARED RIDE DETAILS
Ride owners and admins have a Details button showing the driver and names/emails of passengers who reserved seats. This information is protected from unrelated users and public listings.
ADMIN VEHICLE TABS
All, Cars, Bikes, Scooters and Electric filter the pricing/stock table. The Refresh button is removed. Dashboard data loads on opening the admin view and after actions.
Digital Payment is now one panel. Digital Unlock, Vehicle Security, and Security & Fleet Health are removed.

INDEPENDENT USER AND ADMIN LOGIN
User and admin portals now use separate server sessions and HttpOnly cookies. You can remain logged in with two different emails in the same browser tab. Signing in/out in one portal does not change the other. Admin-only routes require the admin session; a customer session never grants admin access.
Upgrade: stop the server, extract this ZIP, and copy your existing mobility-data.json into the new folder. Existing accounts, admin roles, favorites, bookings and rides are preserved. Log in to each portal separately after restarting. A previous session that displayed Administrator on the user side can be cleared by logging out there and logging back in with your personal email.

Shared ride fixes: the name entered in Offer a Ride is saved and displayed as the driver name. Existing offers retain their previously saved name. Details is available on every ride to logged-in users, showing the offerer and accepted passenger names. Contact emails are visible to the owner/admin. Owners can delete their offers; passengers can cancel their own seats, returning availability. Other users see a disabled Delete Ride button. Admin can delete any ride.

Admin Registered Users: Delete permanently removes a customer account after confirmation, ends its sessions, cancels bookings, removes offered rides, and releases its reserved shared-ride seats. Admin accounts cannot be deleted. Cancelled booking records are retained with the customer name, email and phone cleared. Demo payments do not issue real refunds.

User logins are stored separately per browser tab. Open localhost:8000 in two normal tabs and sign in with different accounts to test shared rides. Refresh preserves each tab login; logout affects that tab session. New tabs require login. Duplicating a tab may copy its initial login; signing into another account then separates it. Existing cookie-only sessions require one new login in the updated user portal. Admin login remains separate.
