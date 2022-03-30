import flask, os
from kubernetes import client, config

app = flask.Flask(__name__)

# Create Kubernetes API usable function
def kubeapi():
    config.load_incluster_config()
    v1 = client.CoreV1Api()
    return v1
    
# Parse POD list to a string, add line breaks
def parse_pod_list(pod_lst):
    output = ''
    for item in pod_lst:
        output = output + f'{item}<br>\n'
    return output


@app.route('/pods')
def pods():
    results = []
    # Use the KubeAPI to list all pods
    ret = kubeapi().list_pod_for_all_namespaces(watch=False)
    for i in ret.items:
        # Append each POD IP, Namespace and Name to the list, use &emsp; to create tab like view for html
        results.append("%s&emsp;%s&emsp;%s" %
              (i.status.pod_ip, i.metadata.namespace, i.metadata.name))
    output = parse_pod_list(results)

    return '''<html>
    <head>
        <title>Pods addersses</title>
    </head>
    <body>
        ''' + output + '''
    </body>
    </html>'''


@app.route('/me')
def me():
    # Return POD information for this specific POD
    ret = kubeapi().list_namespaced_pod(namespace='default')
    for i in ret.items:
        if 'flask-kubeapi' in i.metadata.name:
            output = f'{i.metadata.name}&emsp;{i.status.pod_ip}'


    return '''<html>
    <head>
        <title>Me :)</title>
    </head>
    <body>
        ''' + output + '''
    </body>
    </html>'''



@app.route('/health')
def health():
    # Check if the environment variable "ENV" exists and return output for each case.
    if os.environ.get("ENV") == None:
        output = "App OK - No ENV veriable"
    else:
        output = f'App OK - ENV: {os.environ.get("ENV")}'
    
    return '''<html>
    <head>
        <title>ENV</title>
    </head>
    <body>
    ''' + f'{output}'  + '''
    </body>
    </html>'''

@app.route('/')
def index():
    # Welcome page 
    return '''<html>
    <head>
        <title>Welcome - kubeapi!</title>
    </head>
    <body>
        This is a the main page!<br><br>
        If you're seeing this page this means that the server is running properly
    </body>
    </html>'''


if __name__ == '__main__':
    app.run(host='0.0.0.0', port='8080')
