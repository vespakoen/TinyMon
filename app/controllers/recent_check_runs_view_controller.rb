class RecentCheckRunsViewController < CheckRunsViewController
  include ActivityTabs
  include RootController
  
  def init
    self.navigationItem.titleView = activity_tabs(0)
    super
  end
  
  def viewDidLoad
    super
    
    on_refresh do
      load_data
    end
  end
  
  def tableView(tableView, cellForRowAtIndexPath:indexPath)
    if loading
      loading_cell
    else
      cell = tableView.dequeueReusableCellWithIdentifier('Cell')
      cell ||= UITableViewCell.alloc.initWithStyle(UITableViewCellStyleSubtitle, reuseIdentifier:'Cell')
    
      check_run = check_runs[indexPath.row]
      cell.textLabel.text = check_run.health_check.name
      cell.detailTextLabel.text = check_run.health_check.site.name + ", " + Time.ago_in_words(check_run.created_at_to_now)
      cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator
      cell.imageView.image = UIImage.imageNamed(check_run.status)
      cell
    end
  end
  
  def load_data
    TinyMon.when_reachable do
      CheckRun.recent do |results|
        if results
          self.all_check_runs = results
          change_filter(@filter)
        else
          TinyMon.offline_alert
        end
        done_loading
        end_refreshing
      end
    end
  end
end
