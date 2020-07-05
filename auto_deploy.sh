# #!/bin/bash

echo "Deploying your application."

terraform init
terraform validate
terraform plan -out demotfplan
terraform apply demotfplan

ALB_DNS=$(terraform output ecs_alb_dns_name)


RESPONSE_CODE=$(curl -o /dev/null -s -w "%{http_code}\n" ${ALB_DNS}/health-check)
echo 

while [ $RESPONSE_CODE -ne 200 ]; do
    echo "Website is still launching ......"
    sleep 5
    RESPONSE_CODE=$(curl -o /dev/null -s -w "%{http_code}\n" ${ALB_DNS}/health-check)
done

echo "Health check status code ${RESPONSE_CODE}. Website is ready!"
echo "Start auto testing"


AUTO_TEST_NUMBER=1

while [ $AUTO_TEST_NUMBER -le 3 ]; do
	TEST_TITLE="Test task ${AUTO_TEST_NUMBER}"

	echo "Start testing ${AUTO_TEST_NUMBER}"

    # post data via api
	RESPONSE=$(curl -o /dev/null -s -w "%{http_code}\n" --header "Content-Type: application/json" \
	  --request POST \
	  --data '{"title":"","priority":1000,"completed":false,"Title":"'"${TEST_TITLE}"'"}' \
	  ${ALB_DNS}/api/task/)

    sleep 1

	if [ $RESPONSE -eq 200 ]; then
		echo "${TEST_TITLE} is succeed!"
	else
		echo "${TEST_TITLE} is failed"
		echo "Go for another test"
	fi

	AUTO_TEST_NUMBER=$((AUTO_TEST_NUMBER + 1))
done

echo
ALL_DATA=$(curl -sb -H "Accept: application/json" ${ALB_DNS}/api/task/)

echo "Print all data"
echo $ALL_DATA

# options to clean up all resources or mannually perform other testing 

while true; do
    read -p "Would you like to destroy the demo resources now(y/n)? " yn
    case $yn in
        [Yy]* ) echo Deleting the demo resources; terraform destroy; break;;
        [Nn]* ) echo Please use \'terraform destroy\' to remove the stack mannually after testing; 
                echo
                echo Please visit $ALB_DNS for further testing!
                exit;;
        * ) echo "Please answer yes or no.";;
    esac
done