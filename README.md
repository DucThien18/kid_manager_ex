## CÀI LẠI PUB GET NẾU CẦN
flutter pub get

## mẫu user collection
### Parent
{
  "uid": "PARENT_UID",
  "role": "parent",

  "email": "mom@mail.com",
  "displayName": "Mom",
  "phone": "+84 912 345 678",
  "photoUrl": "https://example.com/mom.png",

  "locale": "vi",
  "timezone": "Asia/Ho_Chi_Minh",

  "createdAt": "<timestamp>",
  "lastActiveAt": "<timestamp>",

  "subscription": {
    "plan": "free",
    "status": "active",
    "startAt": "<timestamp>",
    "endAt": null
  }
}


### Child

{
  "uid": "CHILD_UID",
  "role": "child",

  "email": "ben@mail.com",
  "displayName": "Ben",
  "phone": null,
  "photoUrl": "https://example.com/ben.png",

  "locale": "vi",
  "timezone": "Asia/Ho_Chi_Minh",

  "createdAt": "<timestamp>",
  "lastActiveAt": "<timestamp>",

  "parentUid": "PARENT_UID"
}

## block apps schemal
blocked_items/{userId}/apps/{packageName}

{
  "allowed": false,
  "iconBase64": "iVBORw0KGgoAAAANSUhEUgAA...",
  "name": "ChildTrackerApp",
  "packageName": "com.example.childtrackerapp",
  "usageTime": "0h 3m",
  "lastSeen": "2026-02-03T10:30:00Z"
}



