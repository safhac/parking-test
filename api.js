var jsonServer = require('json-server')

// Returns an Express server
var server = jsonServer.create()


// Set default middlewares (logger, static, cors and no-cache)
server.use(jsonServer.defaults())


var router = jsonServer.router('db.json')
server.use(router)

// server.use(jsonServer.bodyParser)
// server.use((req, res, next) => {
//   if (req.method === 'POST') {
//     req.body.createdAt = Date.now()
//     console.log(req.body);
    
//   }
//   // Continue to JSON Server router
//   next()
// })

console.log('Listening at 4000')
server.listen(4000)