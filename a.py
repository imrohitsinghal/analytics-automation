"""
This script demonstrates how to use mitmproxy's filter pattern in scripts.
"""
from mitmproxy import flowfilter
from mitmproxy import ctx, http
import pickle
import json


class Filter:
    def __init__(self):
        self.filter: flowfilter.TFilter = None

    def configure(self, updated):
        self.filter = flowfilter.parse(ctx.options.flowfilter)

    def load(self, l):
        l.add_option( "flowfilter", str, "", "Check that flow matches filter.")

    """
    def start(self, argv):
        if len(argv) != 1:
            raise ValueError('Usage: -s "modify-response-body.py file-name"')
        self.old = argv[1]    
    """
    def response(self, flow: http.HTTPFlow) -> None:
        """ if flowfilter.match(self.filter, flow):
            ctx.log.info("Flow matches filter:")
            ctx.log.info(flow)
        """
        if (flow.request.url.find("https://www.thoughtworks.com") != -1):
            request_headers = [{"name": k, "value": v} for k, v in flow.request.headers.items()]
            response_headers = [{"name": k, "value": v} for k, v in flow.response.headers.items()]
            file = open("a.json","a")
            print ("################################")
            #json.dump("For " + flow.request.url, file, indent=1)
            #json.dump(flow.request.method + " " + flow.request.path + " " + flow.request.http_version, file, indent=1)
            #json.dump("HTTP REQUEST HEADERS", file, indent=1)
            json.dump(request_headers, file, indent=1)
            #json.dump("//n" + "HTTP RESPONSE HEADERS", file, indent=1)
            #json.dump(response_headers,file, indent=1)
            file.close()

addons = [Filter()]