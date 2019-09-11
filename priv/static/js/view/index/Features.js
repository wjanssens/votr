Ext.define('Votr.view.index.Features', {
    extend: 'Ext.Container',
    alias: 'widget.index.features',
    defaults: {
        margin: 16,
    },
    layout: "hbox",
    items: [
        { flex: 1 },
        {
            width: 300,
            layout: "vbox",
            items: [
                { html: "Something", cls: "h" },
                { html: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.", cls: "p" }
            ]
        },
        {
            width: 300,
            layout: "vbox",
            items: [
                { html: "Something", cls: "h" },
                { html: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.", cls: "p" }
            ]
        },
        {
            width: 300,
            layout: "vbox",
            items: [
                { html: "Something", cls: "h" },
                { html: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.", cls: "p"}
            ]
        },
        { flex: 1 }
    ]
});
