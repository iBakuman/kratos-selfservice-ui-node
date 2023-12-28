// Copyright © 2022 Ory Corp
// SPDX-License-Identifier: Apache-2.0
import expressWinston from "express-winston"
import winston from "winston"

const config = {
  level: 'silly',
  format: winston.format.cli({ colors: { info: 'blue' } }),
  transports: [new winston.transports.Console()],
}
export const logger = winston.createLogger(config)
export const middleware = expressWinston.logger({ winstonInstance: logger })
