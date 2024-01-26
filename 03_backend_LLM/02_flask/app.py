import json
import os

import requests
from flask import Flask, Response, request, stream_with_context
from flask_cors import CORS


app = Flask(__name__)
CORS(app)

OPENAI_API_KEY = os.environ.get("OPENAI_API_KEY", 8080)


@app.route('/', methods=['POST'])
def chat():
    data = request.get_json()
    content = data.get('content', '')

    headers = {
        'Content-Type': 'application/json',
        'Authorization': f'Bearer {OPENAI_API_KEY}',
    }

    payload = {
        'model': 'gpt-3.5-turbo',
        'messages': [
            {'role': 'system', 'content': 'You are a helpful assistant.'},
            {'role': 'user', 'content': content}
        ],
        'stream': True
    }

    response = requests.post('https://api.openai.com/v1/chat/completions',
                             headers=headers,
                             json=payload,
                             stream=True)

    def generate():
        accumulated_data = ''
        for chunk in response.iter_content(chunk_size=1024):
            if chunk:
                accumulated_data += chunk.decode('utf-8')
                if '\n\n' in accumulated_data:
                    *completed, accumulated_data = accumulated_data.split('\n\n')
                    for json_object in completed:
                        json_object = json_object.replace('data: ', '').strip()
                        if json_object == '[DONE]':
                            continue
                        try:
                            if json_object:
                                json_data = json.loads(json_object)
                                text = json_data.get('choices', [{}])[0].get(
                                    'delta', {}).get('content', '')
                                if text:
                                    yield text
                        except json.JSONDecodeError as e:
                            app.logger.error(f"JSON decoding error: {e}")
                            app.logger.error(f"Faulty JSON: {json_object}")

    return Response(stream_with_context(generate()), content_type='text/plain')


if __name__ == "__main__":
    app.run(debug=True,
            host="0.0.0.0",
            port=int(os.environ.get("PORT", 8080)))
