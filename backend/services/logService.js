const winston = require('winston');
const path = require('path');

const logger = winston.createLogger({
    level: 'debug',
    format: winston.format.combine(
        winston.format.timestamp(),
        winston.format.printf(
            ({ timestamp, level, message }) =>
                `${timestamp} [${level.toUpperCase()}] ${message}`
        )
    ),
    transports: [
        new winston.transports.Console(),
        new winston.transports.File({
            filename: path.join(__dirname, '..', 'app.log'),
        }),
    ],
});

const logError = (...args) => logger.error(args.join(' '));
const logInfo = (...args) => logger.info(args.join(' '));
const logDebug = (...args) => logger.debug(args.join(' '));

module.exports = { logError, logInfo, logDebug, logger };
