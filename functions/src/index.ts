import * as functions from "firebase-functions";
import * as admin from "firebase-admin";

admin.initializeApp();

/**
 * Khi user được tạo trong Firestore
 * → copy parentUid sang Realtime DB
 */
export const mirrorUserToRtdb = functions.firestore
  .document("users/{uid}")
  .onCreate(async (snap, context) => {

    const data = snap.data();
    const uid = context.params.uid;

    const parentUid = data.parentUid || null;

    await admin.database()
      .ref(`users/${uid}`)
      .set({
        parentUid: parentUid,
      });

    console.log(`Mirrored user ${uid} → RTDB`);
  });
