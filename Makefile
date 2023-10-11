.PHONY: clean env package

clean:
	rm -rf package.zip
	rm -rf build
	rm -rf dist

env:
	( \
		export PATH="${HOME}/.poetry/bin:${PATH}" && \
		poetry install \
	)

package: clean env
	( \
		bash scripts/package.sh \
	)

run:
	( \
		export PATH="${HOME}/.poetry/bin:${PATH}" && \
		export AWS_PROFILE=cloudeng-test-account-dev-engineer && \
		export AWS_REGION=us-east-1 && \
		poetry run python run.py \
	)
