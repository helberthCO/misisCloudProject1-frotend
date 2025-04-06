export const backendUrl = process.env.BACKEND_URL || 'http://127.0.0.1:8080';
console.log(`Backend URL: ${backendUrl}`);

export default {
  backendUrl
}