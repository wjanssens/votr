Ext.define('Votr.store.Languages', {
    extend: 'Ext.data.Store',
    model: 'Votr.model.Language',
    data: [
        {value: 'default',  text: '* Default *'},
        {value: 'zh', text: '中文'},
        {value: 'es', text: 'Español'},
        {value: 'en', text: 'English'},
        {value: 'hi', text: 'हिन्दी, हिंदी'},
        {value: 'ar', text: 'العربية'},
        {value: 'pt', text: 'Português'},
        {value: 'bn', text: 'বাংলা'},
        {value: 'ru', text: 'Русский'},
        {value: 'ja', text: '日本語'},
        {value: 'de', text: 'Deutsch'},
        {value: 'ko', text: '한국어'},
        {value: 'fr', text: 'Français'},
        {value: 'te', text: 'తెలుగు'},
        {value: 'tr', text: 'Türkçe'},
        {value: 'ta', text: 'தமிழ்'},
        {value: 'vi', text: 'Tiếng Việt'},
        {value: 'ur', text: 'اردو'}
    ]
});
