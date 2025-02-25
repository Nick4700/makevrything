# Uygulama Adı: everything

## Genel Bakış

Bu uygulama, kullanıcıların kodlama bilgisine ihtiyaç duymadan fikirlerini HTML web dosyalarına dönüştürmelerini sağlar. Kullanıcı, chatbot ile etkileşime girerek HTML içeriğini oluşturur, yapılan değişiklikler anında canlı önizleme ile gözlemlenir ve çalışma tamamlandığında dosya kütüphanesine kaydedilir. İleride, kaydedilen dosyalar şablon olarak kullanılabilir veya "library/lives" bölümünden interaktif web sürümüne dönüştürülebilir.

## Uygulama Akışı

1. _Hoş Geldin Ekranı_

   - Uygulama açıldığında kullanıcıya bir hoş geldin ekranı gösterilir.
   - Bu ekranda uygulamanın temel işlevleri ve kullanım şekli hakkında kısa bilgiler verilir.
   - Kullanıcı "Başla" veya benzeri bir buton aracılığıyla ana ekrana yönlendirilir.

2. _Ana Ekran (Home)_

   - Kullanıcı, ana ekranda chatbot ile etkileşime girer.
   - Ekran iki ana bileşenden oluşur:
     - _Chat Alanı:_ Kullanıcının HTML oluşturma ve düzenleme ile ilgili komutlarını girebileceği metin alanı.
     - _Canlı Önizleme:_ Chatbot’un verdiği yanıtlara göre oluşturulan HTML içeriğinin(web sayfası) gerçek zamanlı olarak gösterildiği bölüm.
   - Kullanıcı, chat aracılığıyla gönderdiği komutlara göre HTML dosyasını oluşturur ve anında web görünümünü gözlemler.

3. _HTML Oluşturma ve Düzenleme_

   - _İlk Oluşturma:_ Kullanıcı, chatbot ile konuşarak HTML iskeletini ve içerik öğelerini belirler.
   - _Canlı Güncelleme:_ Chatbot’un cevabı anında HTML dosyasına yansıtılır; canlı önizleme sayesinde sonuç kontrol edilir.
   - _Düzenleme İstekleri:_ Kullanıcı, chat üzerinden ek düzenlemeler talep edebilir. Chatbot, gelen komutlara göre HTML kodunda değişiklik yapar ve önizleme güncellenir.

4. _Dosya Kaydetme_

   - Çalışma tamamlandığında kullanıcı “Kayıt” butonuna basar.
   - Oluşturulan HTML dosyası, uygulamanın kütüphane (library) bölümüne eklenir.

5. _Kütüphane ve Şablonlar_
   - _Kütüphane Yönetimi:_ Kaydedilen dosyalar kütüphane bölümünde saklanır. Kullanıcı daha sonra bu dosyaları görüntüleyebilir, düzenleyebilir veya silebilir.
   - _Şablon Kullanımı:_ Kullanıcılar, kütüphaneden hazır şablonlar seçip, bunlar üzerinde çalışmaya devam edebilir.
   - _Interaktif Web Sürümü:_ Seçilen dosya, "library/lives" bölümünde aktif hale getirilir ve gerçek web etkileşimi sağlanır.

## Uygulama Özellikleri

- _Kullanıcı Dostu Arayüz:_ Basit, modern ve sezgisel bir kullanıcı deneyimi sunar.
- _Chatbot Entegrasyonu:_ Doğal dil işleme teknolojisiyle kullanıcı komutlarını anlayan ve HTML koduna dönüştüren entegre chatbot.
- _Canlı Önizleme:_ Yapılan değişikliklerin anında görüntülenebilmesi sayesinde hızlı geri bildirim.
- _Dinamik Düzenleme:_ Kullanıcının chat üzerinden gönderdiği yeni istekler doğrultusunda HTML dosyası üzerinde anlık düzenlemeler.
- _Dosya Yönetimi ve Kütüphane:_ Çalışmaların kaydedilip, düzenlenebileceği, şablon olarak kullanılabileceği merkezi bir dosya yönetim sistemi.
- _Interaktif Web Deneyimi:_ Kütüphaneden çıkarılan dosyaların “lives” bölümünde gerçek web etkileşimine dönüştürülmesi.

## Gereksinimler

Frontend: Flutter
Backend/Database: a flask web server
AI Processing: DeepSeek

## Kullanım Senaryoları

1. _Yeni HTML Dosyası Oluşturma:_

   - Kullanıcı, ana ekranda chatbot ile konuşarak HTML dosyasını sıfırdan oluşturur.
   - Canlı önizleme sayesinde, yapılan her değişiklik anında ekranda gözlemlenir.

2. _Dosya Düzenleme:_

   - Oluşturulan dosya üzerinde ek düzenlemeler istenildiğinde, kullanıcı chat aracılığıyla yeni komutlar gönderir.
   - Chatbot, mevcut HTML koduna gerekli değişiklikleri uygular ve canlı önizleme güncellenir.

3. _Dosya Kaydetme ve Kütüphane Yönetimi:_

   - Çalışma tamamlandığında, kullanıcı “Kayıt” butonuna basarak dosyayı kütüphaneye ekler.
   - Kütüphaneden, kullanıcı daha sonra düzenlemeye devam etmek veya şablon olarak kullanmak üzere dosyayı seçer.

4. _Canlı Web Etkileşimi:_
   - Kaydedilen dosya, kütüphaneden çıkarılarak “library/lives” bölümünde interaktif web sürümüne dönüştürülür.
   - Bu sürümde kullanıcı, web sayfasıyla doğrudan etkileşime girebilir.

## Özet

Bu uygulama, kullanıcıların kodlama bilgisi olmadan fikirlerini HTML web dosyalarına dönüştürmelerini sağlayan, chatbot entegrasyonu ve canlı önizleme özelliklerine sahip yenilikçi bir platformdur. Kullanıcı dostu arayüzü, dinamik düzenleme ve dosya yönetimi özellikleri ile hem yeni başlayanlara hem de deneyimli kullanıcılara pratik bir çözüm sunar. Geliştiriciler, bu dokümanı uygulamanın iş akışını ve teknik gereksinimlerini göz önünde bulundurarak projeyi kolayca hayata geçirebilirler.

## Veritabanı Şeması (Frontend)

### Kullanıcı (User)

typescript
interface User {
id: string;
email: string;
displayName: string;
photoURL?: string;
createdAt: timestamp;
lastLoginAt: timestamp;
preferences: {
theme: 'light' | 'dark' | 'system';
language: string;
}
}

### Sohbet Geçmişi (ChatHistory)

typescript
interface ChatHistory {
id: string;
userId: string;
title: string;
createdAt: timestamp;
updatedAt: timestamp;
messages: ChatMessage[];
htmlContent: string;
isArchived: boolean;
}
interface ChatMessage {
id: string;
role: 'user' | 'assistant';
content: string;
timestamp: timestamp;
}

### Kütüphane Öğesi (LibraryItem)

typescript
typescript
interface LibraryItem {
id: string;
userId: string;
chatHistoryId: string;
title: string;
description?: string;
htmlContent: string;
createdAt: timestamp;
updatedAt: timestamp;
isLive: boolean;
liveUrl?: string;
tags: string[];
}

## Klasör Yapısı

everything/
├── android/
├── ios/
├── lib/
│ ├── main.dart
│ ├── app.dart
│ ├── config/
│ │ ├── theme.dart
│ │ ├── routes.dart
│ │ └── constants.dart
│ ├── core/
│ │ ├── services/
│ │ │ ├── auth_service.dart
│ │ │ ├── chat_service.dart
│ │ │ ├── storage_service.dart
│ │ │ └── api_service.dart
│ │ ├── models/
│ │ │ ├── user.dart
│ │ │ ├── chat_history.dart
│ │ │ └── library_item.dart
│ │ └── utils/
│ │ ├── validators.dart
│ │ └── helpers.dart
│ ├── features/
│ │ ├── auth/
│ │ │ ├── screens/
│ │ │ ├── widgets/
│ │ │ └── controllers/
│ │ ├── home/
│ │ │ ├── screens/
│ │ │ ├── widgets/
│ │ │ └── controllers/
│ │ └── library/
│ │ ├── screens/
│ │ ├── widgets/
│ │ └── controllers/
│ ├── shared/
│ │ ├── widgets/
│ │ └── styles/
│ └── providers/
│ ├── auth_provider.dart
│ ├── chat_provider.dart
│ └── theme_provider.dart
├── assets/
│ ├── images/
│ ├── icons/
│ └── fonts/
├── test/
└── pubspec.yaml

### Klasör Açıklamaları

- **lib/**: Ana uygulama kodunun bulunduğu dizin

  - **config/**: Uygulama yapılandırma dosyaları
  - **core/**: Temel servisler, modeller ve yardımcı fonksiyonlar
  - **features/**: Özellik tabanlı modüller
  - **shared/**: Paylaşılan widget'lar ve stiller
  - **providers/**: Durum yönetimi sağlayıcıları

- **assets/**: Uygulama kaynaklarının bulunduğu dizin

  - **images/**: Görsel dosyaları
  - **icons/**: İkon dosyaları
  - **fonts/**: Yazı tipleri

- **test/**: Test dosyalarının bulunduğu dizin
