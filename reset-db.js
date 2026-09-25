/**
 * reset-db.js
 * Apaga todas as coleções do MongoDB (psicologos, pacientes, horarios, agendas).
 * O DataInitializer do backend vai recriar os dados de seed automaticamente
 * na próxima vez que o servidor subir.
 *
 * Uso: npm run reset:db
 */

const { MongoClient } = require('mongodb');

const MONGO_URL = 'mongodb://localhost:27017';
const DB_NAME = 'mindDB';

// Coleções que serão apagadas (dados de runtime)
const COLLECTIONS_TO_DROP = ['psicologos', 'pacientes', 'horarios', 'agendas'];

async function resetDb() {
  const client = new MongoClient(MONGO_URL);

  try {
    await client.connect();
    console.log('Conectado ao MongoDB.');

    const db = client.db(DB_NAME);
    const existingCollections = (await db.listCollections().toArray()).map(c => c.name);

    for (const col of COLLECTIONS_TO_DROP) {
      if (existingCollections.includes(col)) {
        await db.collection(col).drop();
        console.log(`  ✓ Coleção '${col}' apagada.`);
      } else {
        console.log(`  - Coleção '${col}' não existe, ignorando.`);
      }
    }

    console.log('\nReset concluído! Reinicie o backend para re-popular com os dados iniciais.');
  } catch (err) {
    console.error('Erro ao resetar o banco de dados:', err);
    process.exit(1);
  } finally {
    await client.close();
  }
}

resetDb();
