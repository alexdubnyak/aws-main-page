#!/bin/bash

# Конфигурация проекта
BUCKET_NAME="graebert-dev-projects"
BUILD_FILE="index.html"
FAVICON_FILE="favicon.svg"
CSS_FILE="styles.css"

echo "🚀 Начинаем деплой AWS Main Page..."

# Проверяем, что AWS CLI установлен
if ! command -v aws &> /dev/null; then
  echo "❌ AWS CLI не установлен. Пожалуйста, установите его: https://aws.amazon.com/cli/"
  exit 1
fi

# Проверяем, что AWS настроен
if ! aws sts get-caller-identity &> /dev/null; then
  echo "❌ AWS CLI не настроен. Запустите: aws configure"
  exit 1
fi

# Проверяем, что файлы существуют
if [ ! -f "$BUILD_FILE" ]; then
    echo "❌ Файл $BUILD_FILE не найден"
    exit 1
fi

if [ ! -f "$FAVICON_FILE" ]; then
    echo "❌ Файл $FAVICON_FILE не найден"
    exit 1
fi

if [ ! -f "$CSS_FILE" ]; then
    echo "❌ Файл $CSS_FILE не найден"
    exit 1
fi

echo "📄 Загружаем главную страницу..."
aws s3 cp $BUILD_FILE s3://$BUCKET_NAME/ --cache-control "max-age=300"

if [ $? -ne 0 ]; then
    echo "❌ Ошибка при загрузке главной страницы"
    exit 1
fi

echo "🔥 Загружаем фавикон..."
aws s3 cp $FAVICON_FILE s3://$BUCKET_NAME/ --cache-control "max-age=31536000"

if [ $? -ne 0 ]; then
    echo "❌ Ошибка при загрузке фавикона"
    exit 1
fi

echo "🎨 Загружаем стили CSS..."
aws s3 cp $CSS_FILE s3://$BUCKET_NAME/ --cache-control "max-age=31536000" --content-type "text/css"

if [ $? -ne 0 ]; then
    echo "❌ Ошибка при загрузке CSS файла"
    exit 1
fi

echo "✅ Деплой завершен успешно!"
echo "🌐 Главная страница доступна по адресу: https://graebert-dev-projects.s3-website-eu-west-1.amazonaws.com/"
echo ""
echo "📋 Развернутые проекты:"
echo "   🏠 Main Page: https://graebert-dev-projects.s3-website-eu-west-1.amazonaws.com/"
echo "   🔍 CLI Search: https://graebert-dev-projects.s3-website-eu-west-1.amazonaws.com/cli-search/"
echo "   📄 Print to PDF: https://graebert-dev-projects.s3-website-eu-west-1.amazonaws.com/print-to-pdf/"
