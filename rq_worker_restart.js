exports.handler = async function (event, context) {
  // Import required AWS SDK clients and commands for Node.js
  const aws = require("aws-sdk");
  aws.config.update({ region: "us-west-2" });
  const ecs = new aws.ECS();

  var params = {
    service_name: process.env.SERVICE_NAME,
    cluster_name: process.env.CLUSTER_NAME,
    forceNewDeployment: process.env.FORCE_NEW_DEPLOYMENT,
  };

  ecs.updateService(params, function (err, data) {
    if (err) console.log(err, err.stack); // an error occurred
    else console.log(data); // successful response
  });
  // Set the AWS region
  const REGION = "us-west-2"; //e.g. "us-east-1"

  console.log("EVENT: \n" + JSON.stringify(event, null, 2));
  return context.logStreamName;
};

// Create EC2 service object
// const ec2client = new EC2Client({ region: REGION });

// const run = async () => {
//   try {
//     const data = await ec2client.send(new DescribeInstancesCommand({}));
//     console.log("Success", JSON.stringify(data));
//   } catch (err) {
//     console.log("Error", err);
//   }
// };
// run();

//would not need line 3 or 17
