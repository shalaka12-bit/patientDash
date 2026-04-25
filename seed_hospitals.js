// seed_hospitals.js
// Run with Node.js to populate Firestore with sample hospitals.
// Usage: node seed_hospitals.js
// Requires: npm install firebase-admin

const admin = require('firebase-admin');
const serviceAccount = require('./serviceAccountKey.json'); // download from Firebase Console

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});

const db = admin.firestore();

const hospitals = [
  {
    name: 'City General Hospital',
    address: '12 MG Road, Mumbai, Maharashtra 400001',
    latitude: 19.0760,
    longitude: 72.8777,
    hasICU: true,
    hasOxygen: true,
    availableBeds: 24,
    phone: '+91-22-12345678',
    rating: 4.5,
  },
  {
    name: 'Sunrise Medical Centre',
    address: '45 Andheri West, Mumbai 400058',
    latitude: 19.1197,
    longitude: 72.8464,
    hasICU: true,
    hasOxygen: true,
    availableBeds: 12,
    phone: '+91-22-98765432',
    rating: 4.2,
  },
  {
    name: 'Apollo Emergency Hospital',
    address: '8 Bandra Kurla Complex, Mumbai 400051',
    latitude: 19.0655,
    longitude: 72.8678,
    hasICU: false,
    hasOxygen: true,
    availableBeds: 8,
    phone: '+91-22-11223344',
    rating: 4.7,
  },
  {
    name: 'Green Valley Clinic',
    address: '22 Powai, Mumbai 400076',
    latitude: 19.1180,
    longitude: 72.9057,
    hasICU: false,
    hasOxygen: false,
    availableBeds: 5,
    phone: '+91-22-55667788',
    rating: 3.9,
  },
];

async function seed() {
  const batch = db.batch();
  hospitals.forEach((h) => {
    const ref = db.collection('hospitals').doc();
    batch.set(ref, h);
  });
  await batch.commit();
  console.log('✅ Hospitals seeded successfully!');
  process.exit(0);
}

seed().catch(console.error);
