Ext.define('Votr.view.voter.Candidate', {
    extend: 'Ext.panel.Panel',
    alias: 'widget.voter.candidate',
    layout: {
        type: 'hbox', pack: 'center'
    },
    padding: 4,

    setData: function (data) {
        this.callParent(arguments);
        this.down('#name').setHtml(data.name);
        this.down('#desc').setHtml(data.description || '');

        if (data.status == 'withdrawn') {
            this.add({ width: 144, height: 48, padding: 16, style: 'font-size: 1.25em; text-align: center;', html: 'Withdrawn'})
        } else if (data.status == 'elected') {
            this.add({ width: 144, height: 48, padding: 16, style: 'font-size: 1.25em; text-align: center;', html: '&check; Elected'})
        } else if (data.status == 'excluded') {
            this.add({ width: 144, height: 48, padding: 16, style: 'font-size: 1.25em; text-align: center;', html: '&empty; Excluded'})
        } else {
            var me = this;
            this.add({
                xtype: 'voter.rankfield',
                itemId: 'controls',
                padding: 0,
                data: {
                    rank: data.rank,
                    max: data.max,
                    ranked: data.ranked,
                    status: data.status,
                },
                listeners: {
                    rank: {
                        scope: me,
                        fn: function (newValue, oldValue) {
                            this.getData().rank = newValue;
                            this.fireEvent('rank', newValue, oldValue);
                        }
                    }
                }
            });
        }
    },
    items: [
        {
            xtype: 'image',
            itemId: 'avatar',
            style: 'border-radius: 4px;',
            width: 48,
            height: 48,
            border: 1,
            padding: 0,
            margin: 0,
            src: '../images/guy.png'
        }, {
            xtype: 'panel',
            flex: 1,
            padding: '0 16px',
            layout: {
                type: 'vbox', pack: 'center'
            },
            items: [{
                xtype: 'component',
                itemId: 'name',
                style: 'font-size: 1.25em;'
            }, {
                xtype: 'component',
                itemId: 'desc',
                style: 'color: var(--highlight-color);'
            }]
        }
    ]
});