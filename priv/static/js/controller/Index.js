Ext.define('Votr.controller.Index', {
    extend: 'Ext.app.Controller',
    views: [
        'index.Features',
        'index.Testimonials',
        'index.Hero',
        'index.Organizations',
        'index.Footer',
        'index.Login'
    ],
    models: [
        'Language'
    ],
    stores: [
        'Languages',
        'Colors'
    ]
})
