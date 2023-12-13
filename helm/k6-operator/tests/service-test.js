import http from "k6/http";
import { check, fail } from "k6";

const BASE_URL = `http://${__ENV.HOSTNAME}/`;

export let options = {
  discardResponseBodies: true,
  scenarios: {
    // https://k6.io/docs/test-types/smoke-testing/
    smoke: {
      // https://k6.io/docs/using-k6/scenarios/executors/constant-vus/
      executor: "constant-vus",
      vus: 3, // 2,3 or 5 max for smoke tests
      duration: "1m",
    },
    load: {
      // https://k6.io/docs/using-k6/scenarios/executors/ramping-vus/
      executor: "ramping-vus",
      startVUs: 0,
      stages: [
        { duration: "5m", target: 5 }, // traffic ramp-up from 1 to 25 users over 5 minutes.
        { duration: "30m", target: 5 }, // stay at 25 users for 30 minutes
        { duration: "5m", target: 0 }, // ramp-down to 0 users
      ],
      gracefulRampDown: "0s",
    },
  },
};

export default function () {
  const res = http.get(BASE_URL);

  const checkOutput = check(res, {
    "response code was 200": (res) => res.status == 200,
  });

  // console.log(res.status);

  if (!checkOutput) {
    fail("unexpected response");
  }
}
