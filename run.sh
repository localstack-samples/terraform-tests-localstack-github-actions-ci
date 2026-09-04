docker run --platform linux/x86_64 --rm -v "$PWD":/var/task "public.ecr.aws/sam/build-python3.11" /bin/sh -c "pip3 install -r requirements.txt -t libs; exit"

cd libs && zip -r ../lambda.zip . && cd ..
zip lambda.zip lambda_function.py
rm -rf libs

lstk aws s3 cp image.png s3://original-images/image.png
lstk aws s3 ls s3://resized-images