Ext.define('Votr.view.index.Features', {
    extend: 'Ext.carousel.Carousel',
    alias: 'widget.index.features',
    margin: 16,
    height: 256,
    items: [
        {
            layout: 'vbox',
            defaults: {
                padding: 8
            },
            items: [
                {
                    html: 'Feature Title',
                    style: 'font-size: 2em; text-align: center;'
                }, {
                    html: 'Feature Sub-title',
                    style: 'font-size: 1.25em; text-align: center;'
                }, {
                    layout: 'hbox',
                    defaults: {
                        padding: 8
                    },
                    items: [{
                        html: 'Left Hand Side',
                        flex: 1
                    }, {
                        xtype: 'image',
                        border: true,
                        shadow: true,
                        flex: 1,
                        src: ''
                    }, {
                        html: 'Right Hand Side',
                        flex: 1
                    }]
                }
            ]
        },
        {
            layout: 'vbox',
            defaults: {
                padding: 8
            },
            items: [
                {
                    html: 'Feature Title',
                    style: 'font-size: 2em; text-align: center;'
                }, {
                    html: 'Feature Sub-title',
                    style: 'font-size: 1.25em; text-align: center;'
                }, {
                    layout: 'hbox',
                    defaults: {
                        padding: 8
                    },
                    items: [{
                        xtype: 'image',
                        border: true,
                        shadow: true,
                        src: '',
                        flex: 1
                    }, {
                        html: 'Right Hand Side',
                        flex: 1
                    }]
                }
            ]
        },
        {
            layout: 'vbox',
            defaults: {
                padding: 8
            },
            items: [
                {
                    html: 'Feature Title',
                    style: 'font-size: 2em; text-align: center;'
                }, {
                    html: 'Feature Sub-title',
                    style: 'font-size: 1.25em; text-align: center;'
                }, {
                    layout: 'hbox',
                    defaults: {
                        padding: 8
                    },
                    items: [{
                        html: 'Left Hand Side',
                        flex: 1
                    }, {
                        xtype: 'image',
                        border: true,
                        shadow: true,
                        src: '',
                        flex: 1
                    }]
                }
            ]
        }
    ]
});
