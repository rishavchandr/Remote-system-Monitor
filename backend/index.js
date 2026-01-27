import dotenv from 'dotenv'
import {app} from './src/app.js'
import connectDB from './src/db/index.js';

const PORT = process.env.PORT || 3000;

dotenv.config({
    path: './env'
})

connectDB()

app.listen(PORT , () =>{
    console.log(`server is running at port: ${PORT}`);
    
})