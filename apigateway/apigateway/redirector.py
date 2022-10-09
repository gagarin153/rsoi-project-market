import requests


def redirect(request, host):
    resp = requests.request(
        method=request.method,
        url=request.url.replace(request.host_url, host),
        headers={key: value for (key, value) in request.headers if key != 'Host'},
        data=request.get_data(),
        cookies=request.cookies,
        allow_redirects=False)

    headers = [(name, value) for (name, value) in resp.raw.headers.items()]

    return {'content': resp.content, 'status_code': resp.status_code, 'headers': headers}
