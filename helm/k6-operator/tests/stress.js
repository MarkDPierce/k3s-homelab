import http from "k6/http";
import { check, fail } from "k6";

const BASE_URL = `http://${__ENV.HOSTNAME}/`;

export let options = {
  discardResponseBodies: true,
  scenarios: {
    load: {
      executor: "ramping-vus",
      startVUs: 0,
      stages: [
        { duration: "5m", target: 100 },
        { duration: "30m", target: 1000 },
        { duration: "5m", target: 100 },
        { duration: "5m", target: 0 },
      ],
      gracefulRampDown: "0s",
    },
  },
};

export default function () {
  const res = http.get(BASE_URL);
}
