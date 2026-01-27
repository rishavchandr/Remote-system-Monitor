import {CONFIG} from './config.js'
import {collectMetrics} from './collector.js'
import {sendMetrics} from './sender.js'

let running = true;

const run = async() => {
    if(!running) return

    try {
        const metrics = await collectMetrics();
        await sendMetrics(metrics)

    } catch (error) {
        console.log("Metrics upload failed: ", error)
        process.exit(1)
    }
}

const intervalId = setInterval(run , CONFIG.interval)

process.on('SIGINT' , ()=>{
    running = false
    clearInterval(intervalId)
    process.exit(0)
})