<div {{action 'toggleOpen' on='mouseDown' bubbles=false}} {{bind-attr class=':chosem__value isOpen:chosem__value--open:chosem__value--closed'}}>
    {{#if multiple}}
        {{#if value}}
            <ul>
                {{#each value}}
                    <li>{{name}}</li>
                {{/each}}
            </ul>
        {{else}}
            <em class='chosem__placeholder'>{{placeholder}}</em>
        {{/if}}
    {{else}}
        {{#if value}}
            {{value.name}}
        {{else}}
            <em class='chosem__placeholder'>{{placeholder}}</em>
        {{/if}}
    {{/if}}
    {{#unless multiple}}
        <i {{bind-attr class=':chosem__caret :fa isOpen:fa-caret-up:fa-caret-down'}}></i>
    {{/unless}}
</div>

{{#if isOpen}}
    <div class='chosem__inner'>
        <div class="chosem__search">
            <i class='fa fa-search'></i>
            {{focus-input value=input placeholder='Search'}}
        </div>
        <ul class='chosem__options'>
            {{#if filtered}}
                {{#each item in filtered}}
                    {{#chosem-option
                    select='select'
                    hover='highlight' item=item}}
                        {{emphasiser item.name input}}
                    {{/chosem-option}}
                {{/each}}
            {{else}}
                <li class='chosem__option--noop'>No results match "{{controller.input}}"</li>
            {{/if}}
        </ul>
    </div>
{{/if}}
