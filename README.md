# Scalable sentiment analysis on Twitter data using Benthos and Knative

Based on Carlos Santana's Knative on Kind (KonK): https://github.com/csantanapr/knative-kind

Benthos with sentiment analysis support: https://github.com/mihaitodor/benthos-vader

Twitter dataset source: https://www.kaggle.com/datasets/crowdflower/twitter-airline-sentiment

## Start Kind cluster and install Knative Serving

```shell
> ./install_serving.sh
> kubectl get pods -A
> watch kubectl get pods
```

## Deploy the benthos-vader lambda

```shell
> kubectl create configmap benthos-vader-config --from-file=benthos.yaml=./benthos/benthos_vader.yaml
> ./deploy_benthos_vader.sh
```

## Test sentiment analysis

```shell
> curl -v -X POST -d '{"text": "I love Benthos!"}' http://benthos-vader.default.127.0.0.1.sslip.io/post
```

## Run Postgres and populate the SOURCE table

```shell
> docker run --rm -it -p 5432:5432 -e POSTGRES_PASSWORD=password postgres
> # Populate SOURCE table in DB
> ./populate_db.sh
> # Connect to DB
> pgcli postgres://postgres:password@localhost:5432/postgres
>> SELECT COUNT(*) FROM SOURCE
```

## Run Prometheus

```shell
> prometheus --config.file=prometheus.yaml
> http://localhost:9090/graph?g0.expr=rate(output_sent{}[10s])&g0.tab=0&g0.range_input=5m
```

## Run Benthos batch workflow

```shell
> time benthos -c ./benthos/benthos_batch.yaml
```

## Teardown

```shell
> kind delete cluster --name knative
```
