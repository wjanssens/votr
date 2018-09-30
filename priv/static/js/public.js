Ext.onReady(function () {
    var i18nStore = Ext.create('Ext.data.Store', {
        proxy: {
            fields: [
                {name: 'id', type: 'string', identifier: true},
                {name: 'value',  type: 'string'}
            ],
            type: 'ajax',
            reader: {
                type: 'json'
            }
        },
        autoLoad: false
    });
    i18nStore.getProxy().setUrl(window.location.pathname + "/i18n.json");
    i18nStore.load({
        callback : function(records, operation, success) {
            String.prototype.translate = function translate() {
                var record = i18nStore.getById(this.valueOf());
                if (record === null) {
                    return this.valueOf();
                } else {
                    return record.get('value');
                }
            };

            Ext.application({
                name: 'Votr',
                appFolder: '../js',
                controllers: ['Public'],
                requires: [
                    'Votr.view.public.Main'
                ],
                defaultToken: 'ballots',

                launch: function () {
                    Ext.Viewport.add(Ext.create('Votr.view.public.Main'));
                }
            });
        }
    });

    Ext.get(window.document).on('contextmenu', function (e) {
        e.preventDefault();
        return false;
    });
});