import os
from flask import Flask
from ask_sdk_core.skill_builder import SkillBuilder

app = Flask(__name__)

sb = SkillBuilder()
skill_id = os.getenv('SKILL_ID')
client_id = os.getenv('CLIENT_ID')
client_secret = os.getenv('CLIENT_SECRET')

@app.route('/')
def index():
    return f"Skill ID: {skill_id}, Client ID: {client_id}"

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=int(os.getenv('PORT', 8080)), debug=True)
