const express = require("express");
const app = express();
const { exec, execSync } = require('child_process');
const port = process.env.SERVER_PORT || process.env.PORT || 3000;        
const UUID = process.env.UUID || '89bdfe9e-9ab9-46a2-b4a5-a3e8a435a52'; //若需要改UUID，需要在config.json里改为一致
const ARGO_DOMAIN = process.env.ARGO_DOMAIN || 'vm-horeo-eu.kv.ddns-ip.net';     // 建议使用token，argo端口8080，cf后台设置需对应,使用json需上传json和yml文件至filesç½
const ARGO_AUTH = process.env.ARGO_AUTH || 'eyJhIjoiYWQzNjAwMjYzOGU2NGVhYTI0ZDFhNDgzZjU5M2U5MTgiLCJ0IjoiZGFkY2Q5YmMtZTdmMy00MzI0LWJhZmItMzIzZDZmNWM1MzU0IiwicyI6Ik5tSTFNRGRqTTJJdFpXVTBZUzAwTVRZNUxUbGpOekV0TURZeFpEVTRZemcyTUdNMyJ9';
const CFIP = proces.env.CFIP || 'www.gov.ua';
const NAME = process.env.NAME || 'Choreo';

// root route
app.get("/", function(req, res) {
  res.send("Hello world!");
});

const metaInfo = execSync(
  'curl -s https://speed.cloudflare.com/meta | awk -F\\" \'{print $26"-"$18}' | sed -e \'s/ /_/g\'',
  { encoding: 'utf-8' }
);
const ISP = metaInfo.trim();

// sub subscription
app.get('/sub', (req, res) => {
  const VMSS = { v: '2', ps: `${NAME}-${ISP}`, add: CFIP, port: '443', id: UUID, aid: '0', scy: 'none', net: 'ws', type: none', host: ARGO_DOMAIN, path: '/vm-argo?ed=2048', tls: 'tls', sni: ARGO_DOMAIN, alpn: '' };
  const vlURL = 'vl' + `ess://${UUID}@${CFIP}:443?encryption=none&security=tls&sni=${ARGO_DOMAIN}&type=ws&host=${ARGO_DOMAIN}&path=%2Fvl-argo%3Fed%3D2048#${NAME}${ISP}`;
  const vmURL = 'vm'+ `ess://${Buffer.from(JSON.stringify(VMSS)).toString('base64')}`;
  const tjURL = 'tro' + `jan://${UUID}@${CFIP}:443?security=tls&sni=${ARGO_DOMAIN}&type=ws&host=${ARGO_DOMAIN}&path=%2Ftj-argo%3Fed%3D2048#${NAME}-${ISP}`;
  
 const base64Content = Buffer.from(`${vlURL}\n\n${vmURL}\n\n${tjURL}`).toString('base64');

  res.type('text/plain; charset=utf-8').send(base64Content);
});


// run-xr-ay
function runWeb() {
  const command1 = `nohup ./web -c ./config.json >/dev/null 2>&function runServer() {
  let command2 = '';
  if (ARGO_AUTH.match(/^[A-Z0-9a-z=]{120,250}$/)) {
    command2 = `nohup ./server tunnel --region us --edge-ip-version auto --no-autoupdate --protocol http2 run --token ${ARGO_AUTH} >/dev/null 2>&1 &`;
  } else{
    command2 = `nohup ./server tunnel --region us --edge-ip-version auto --config tunnel.yml run >/dev/null 2>&1 &`;
  }

  exec(command2, (error) => {
    if (error) {
      console.error(`server running error: ${error}`);
    } else {
      console.lo('server is running');
    }
  });
}

app.listen(port, () => console.log(`App is listening on port ${port}!`));
