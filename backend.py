from flask import Flask, request, jsonify
from flask_cors import CORS
from openai import OpenAI
import json

app = Flask(__name__)
CORS(app)

# OpenAI istemcisini oluştur
client = OpenAI(
    api_key="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"
)

# Başlangıç HTML şablonu
BASE_HTML = """
<!DOCTYPE html>
<html lang="tr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Everything</title>
    <style>
        body {{
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 20px;
            line-height: 1.6;
        }}
    </style>
</head>
<body>
    {content}
</body>
</html>
"""


def create_prompt(messages):
    conversation = "\n".join(
        [
            f"{'Kullanıcı' if msg['isUser'] else 'Asistan'}: {msg['content']}"
            for msg in messages
        ]
    )

    return f"""
    Sen bir HTML uzmanısın. Kullanıcının isteklerine göre HTML sayfaları oluşturuyorsun.
    Aşağıdaki konuşmaya göre bir HTML sayfası oluştur veya güncelle.
    Sadece HTML kodunu döndür, başka açıklama ekleme.
    
    Konuşma:
    {conversation}
    
    Lütfen geçerli ve iyi biçimlendirilmiş HTML kodu oluştur.
    """


@app.route("/generate", methods=["POST"])
def generate_html():
    try:
        data = request.json
        messages = data.get("messages", [])

        if not messages:
            return jsonify({"html": BASE_HTML.format(content="<h1>Hoş Geldiniz</h1>")})

        response = client.chat.completions.create(
            model="gpt-4o-mini",
            messages=[
                {
                    "role": "system",
                    "content": "Sen bir HTML uzmanısın. Kullanıcının isteklerine göre HTML sayfaları oluşturuyorsun.",
                },
                {"role": "user", "content": create_prompt(messages)},
            ],
            temperature=0.7,
            max_tokens=2000,
        )

        generated_html = response.choices[0].message.content.strip()

        if not generated_html.strip().startswith("<!DOCTYPE html>"):
            generated_html = BASE_HTML.format(content=generated_html)

        return jsonify({"html": generated_html})

    except Exception as e:
        print(f"Hata: {str(e)}")
        return jsonify({"error": str(e)}), 500


@app.route("/health", methods=["GET"])
def health_check():
    return jsonify({"status": "healthy"})


if __name__ == "__main__":
    app.run(debug=True, host="0.0.0.0", port=5000)
