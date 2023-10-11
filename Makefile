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
