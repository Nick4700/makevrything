from flask import Flask, request, jsonify, render_template_string
from flask_sqlalchemy import SQLAlchemy
from datetime import datetime
import uuid
from dataclasses import dataclass

app = Flask(__name__)
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///apps.db'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
db = SQLAlchemy(app)

@dataclass
class PublishedApp(db.Model):
    id: str
    name: str
    html: str
    is_public: bool
    user_id: str
    created_at: datetime
    updated_at: datetime

    __tablename__ = 'published_apps'

    id = db.Column(db.String(36), primary_key=True)
    name = db.Column(db.String(100), nullable=False)
    html = db.Column(db.Text, nullable=False)
    is_public = db.Column(db.Boolean, nullable=False, default=False)
    user_id = db.Column(db.String(36), nullable=False)
    created_at = db.Column(db.DateTime, nullable=False, default=datetime.utcnow)
    updated_at = db.Column(db.DateTime, nullable=False, default=datetime.utcnow)

# Veritabanını oluştur
with app.app_context():
    db.create_all()

# Uygulama yayınlama endpoint'i
@app.route('/api/apps/publish', methods=['POST'])
def publish_app():
    try:
        data = request.get_json()
        user_id = request.headers.get('User-Id')  # Auth middleware'den gelecek
        
        if not user_id:
            return jsonify({'error': 'Kullanıcı kimliği gerekli'}), 401

        new_app = PublishedApp(
            id=str(uuid.uuid4()),
            name=data['name'],
            html=data['html'],
            is_public=data['isPublic'],
            user_id=user_id
        )
        
        db.session.add(new_app)
        db.session.commit()
        
        return jsonify({
            'success': True,
            'id': new_app.id
        })
    except Exception as e:
        db.session.rollback()
        return jsonify({'error': str(e)}), 500

# Uygulama HTML güncelleme endpoint'i
@app.route('/api/apps/<app_id>/html', methods=['PUT'])
def update_app_html(app_id):
    try:
        data = request.get_json()
        user_id = request.headers.get('User-Id')
        
        app = PublishedApp.query.get(app_id)
        if not app:
            return jsonify({'error': 'Uygulama bulunamadı'}), 404
            
        if not app.is_public and app.user_id != user_id:
            return jsonify({'error': 'Bu işlem için yetkiniz yok'}), 403
        
        app.html = data['html']
        app.updated_at = datetime.utcnow()
        db.session.commit()
        
        return jsonify({'success': True})
    except Exception as e:
        db.session.rollback()
        return jsonify({'error': str(e)}), 500

# Uygulama görüntüleme endpoint'i
@app.route('/apps/<app_id>/<app_name>')
def view_app(app_id, app_name):
    try:
        app = PublishedApp.query.filter_by(id=app_id, name=app_name).first()
        if not app:
            return 'Uygulama bulunamadı', 404

        template = '''
        <!DOCTYPE html>
        <html>
        <head>
            <title>{{ app.name }}</title>
            <meta charset="utf-8">
            <meta name="viewport" content="width=device-width, initial-scale=1">
            <style>
                body { margin: 0; padding: 0; font-family: system-ui, -apple-system, sans-serif; }
                .container { width: 100%; height: 100vh; display: flex; flex-direction: column; }
                .header { 
                    padding: 12px 20px; 
                    background: #f8f9fa; 
                    border-bottom: 1px solid #dee2e6;
                    display: flex;
                    justify-content: space-between;
                    align-items: center;
                }
                .title { 
                    font-size: 1.25rem; 
                    font-weight: 500; 
                    margin: 0;
                    color: #212529;
                }
                iframe { 
                    flex: 1; 
                    border: none; 
                    width: 100%;
                    background: white;
                }
                .save-bar { 
                    padding: 12px 20px; 
                    text-align: right; 
                    background: #f8f9fa;
                    border-top: 1px solid #dee2e6;
                }
                .btn {
                    padding: 8px 16px;
                    background: #0d6efd;
                    color: white;
                    border: none;
                    border-radius: 4px;
                    cursor: pointer;
                    font-size: 0.875rem;
                    transition: background-color 0.2s;
                }
                .btn:hover { background: #0b5ed7; }
                .status {
                    padding: 4px 8px;
                    border-radius: 4px;
                    background: {{ '#198754' if app.is_public else '#6c757d' }};
                    color: white;
                    font-size: 0.75rem;
                }
            </style>
        </head>
        <body>
            <div class="container">
                <div class="header">
                    <h1 class="title">{{ app.name }}</h1>
                    <span class="status">{{ 'Herkese Açık' if app.is_public else 'Özel' }}</span>
                </div>
                <iframe src="/api/apps/{{ app.id }}/content" id="appFrame"></iframe>
                {% if app.is_public %}
                <div class="save-bar">
                    <button class="btn" onclick="saveChanges()">Değişiklikleri Kaydet</button>
                </div>
                {% endif %}
            </div>
            
            {% if app.is_public %}
            <script>
                async function saveChanges() {
                    const btn = document.querySelector(".btn");
                    btn.disabled = true;
                    btn.textContent = "Kaydediliyor...";
                    
                    try {
                        const frame = document.getElementById("appFrame");
                        const html = frame.contentDocument.documentElement.outerHTML;
                        
                        const response = await fetch(`/api/apps/{{ app.id }}/html`, {
                            method: "PUT",
                            headers: {
                                "Content-Type": "application/json",
                            },
                            body: JSON.stringify({ html }),
                        });
                        
                        if (response.ok) {
                            btn.textContent = "Kaydedildi!";
                            setTimeout(() => {
                                btn.disabled = false;
                                btn.textContent = "Değişiklikleri Kaydet";
                            }, 2000);
                        } else {
                            throw new Error("Kaydetme hatası");
                        }
                    } catch (error) {
                        btn.textContent = "Hata!";
                        setTimeout(() => {
                            btn.disabled = false;
                            btn.textContent = "Değişiklikleri Kaydet";
                        }, 2000);
                        console.error("Hata:", error);
                    }
                }
            </script>
            {% endif %}
        </body>
        </html>
        '''
        
        return render_template_string(template, app=app)
    except Exception as e:
        return str(e), 500

# Uygulama içeriği endpoint'i
@app.route('/api/apps/<app_id>/content')
def get_app_content(app_id):
    try:
        app = PublishedApp.query.get(app_id)
        if not app:
            return 'Uygulama bulunamadı', 404
            
        return app.html
    except Exception as e:
        return str(e), 500

# Yayınlanan uygulamaları listele
@app.route('/api/apps/published')
def list_published_apps():
    try:
        apps = PublishedApp.query.order_by(PublishedApp.updated_at.desc()).all()
        return jsonify({
            "apps": [
                {
                    "id": app.id,
                    "name": app.name,
                    "isPublic": app.is_public,
                    "userId": app.user_id,
                    "createdAt": app.created_at.isoformat(),
                    "updatedAt": app.updated_at.isoformat(),
                    "url": f"/apps/{app.id}/{app.name}"
                }
                for app in apps
            ]
        })
    except Exception as e:
        return jsonify({'error': str(e)}), 500

# Kullanıcının yayınladığı uygulamaları listele
@app.route('/api/users/<user_id>/apps')
def list_user_apps(user_id):
    try:
        apps = PublishedApp.query.filter_by(user_id=user_id)\
            .order_by(PublishedApp.updated_at.desc()).all()
        
        return jsonify({
            "apps": [
                {
                    "id": app.id,
                    "name": app.name,
                    "isPublic": app.is_public,
                    "createdAt": app.created_at.isoformat(),
                    "updatedAt": app.updated_at.isoformat(),
                    "url": f"/apps/{app.id}/{app.name}"
                }
                for app in apps
            ]
        })
    except Exception as e:
        return jsonify({'error': str(e)}), 500

if __name__ == '__main__':
    app.run(debug=True)
