App.ProjectsFilter = App.FilterModel.extend

  projects: null

  officeFilterModel: null


  options: (->
    filters =
      currentEmployee: (record) ->
        date = record.get('end_date')
        !date || date >= new Date
      exEmployee: (record) ->
        date = record.get('end_date')
        !!date && date < new Date
      notAllocated: (record) ->
        !record.get('unsellable') && !record.get('currentAllocation')
      onOverhead: (record) ->
        record.get('unsellable')
      onPto: (record) ->
        record.get('currentAllocation.project.vacation')
      onBillable: (record) ->
        record.get('currentAllocation.billable')

    result = []
    result.pushObject App.FilterOption.create
      displayName: 'Anything'
      slug: 'all_projects'
      isDefault: true
      filterFunc: (record) ->
        filters.currentEmployee(record)

    result.pushObject App.FilterOption.create
      displayName: 'Overhead'
      slug: 'overhead'
      isDefault: true
      filterFunc: (record) ->
        filters.currentEmployee(record) &&
          filters.onOverhead(record)

    result.pushObject App.FilterOption.create
      displayName: 'Available'
      slug: 'on_bench'
      isDefault: false
      filterFunc: (record) ->
        filters.currentEmployee(record) &&
          filters.notAllocated(record)

    result.pushObject App.FilterOption.create
      displayName: 'PTO'
      slug: 'pto'
      isDefault: false
      filterFunc: (record) ->
        filters.currentEmployee(record) &&
          filters.onPto(record)

    result.pushObject App.FilterOption.create
      displayName: 'Billable Projects'
      slug: 'billable'
      isDefault: false
      filterFunc: (record) ->
        filters.currentEmployee(record) &&
          filters.onBillable(record)

    result.pushObject App.FilterOption.create
      displayName: 'Are No Longer With The Company'
      slug: 'gone'
      isDefault: false
      filterFunc: (record) ->
        filters.exEmployee(record)

    projects = @get('projects') || []

    sortByName =
      sortProperties: ['sortOrder', 'name']
      content: projects

    projects = Ember.ArrayProxy.createWithMixins(Ember.SortableMixin,sortByName)

    projects.forEach (project) ->
      result.pushObject App.FilterOption.create
        displayName: project.get('name')
        slug: project.get('id')
        data: project
        filterFunc: (record) ->
          record.get('currentAllocation.project') == @get('data')
    result
  ).property('projects')

  officeSelectionDidChange: (->
    offices = @get('officeFilterModel.selectedOptions').mapBy('data')
    if offices.contains(null)
      # default is selected
      @get('options').setEach('visible', true)
    else
      @get('options').forEach (option) ->
        visible = !option.data || offices.any (item) ->
          option.data.get('offices').contains(item)
        option.set('visible', visible)
  ).observes('officeFilterModel.options.@each.selected').on('init')