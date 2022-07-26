Moralis.initialize('xER61aYJQskT98Zc8CISpXfoNpqDwiz3oVisFl60')
Moralis.serverURL = "https://qhdz7rwn4lbw.usemoralis.com:2053/server"

init = async() => {
  window.web3 = await Moralis.Web3.enable()
  const user = await Moralis.User.current()
}

login = async() => {
  await Moralis.Web3.authenticate()
  const user = await Moralis.User.current()
}

logout = async() => await Moralis.User.logout()
getAlerts = async () => {
  const query =  Moralis.Object.extend("Alerts");
  const alerts = await query.find()
  console.log(alerts)
}

init()