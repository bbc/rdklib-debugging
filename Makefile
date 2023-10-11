.PHONY: clean env test package

clean:
	rm -rf package.zip
	rm -rf build
	rm -rf dist

env:
	( \
		export PATH="${HOME}/.poetry/bin:${PATH}" && \
		poetry install \
	)

package: clean env test
	( \
		bash ci/scripts/package.sh \
	)
