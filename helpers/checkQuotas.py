# REQUIREMENT : 
# export GOOGLE_APPLICATION_CREDENTIALS="/path/to/your-service-account-file.json" with the SA having compute.projects.get
# Enable Cloud Quota APIs - https://console.cloud.google.com/apis/library/cloudquotas.googleapis.com?project=fe-dev-sandbox
# python3 -m pip install google-cloud-quotas
# If needed, GRANT roles/serviceusage.serviceUsageViewer and roles/servicemanagement.quotaViewer to your current identityfrom google.cloud import service_usage

from google.cloud import cloudquotas_v1
import pandas as pd

# USER PARAMETERS
project_id = '<PROJECT_ID>'
google_region = 'europe-west1'
google_zone = "" # Leave empty to check across all the region. It will then raise an issue if any zone has insufficient quota.


# CONSTANTS
service= "compute.googleapis.com"
databricks_quotas = pd.DataFrame([
    {"item":"compute.googleapis.com/cpus","value":50,"atScale":2400},
    {"item":"compute.googleapis.com/routes","value":250,"atScale":300},
    {"item":"compute.googleapis.com/subnetworks","value":150,"atScale":275},
    {"item":"compute.googleapis.com/regional_in_use_addresses","value":23,"atScale":500},
    {"item":"compute.googleapis.com/instance_group_managers","value":50,"atScale":500},
    {"item":"compute.googleapis.com/instance_groups","value":100,"atScale":500},
    {"item":"compute.googleapis.com/disks_total_storage","value":5000,"atScale":50000},
    {"item":"compute.googleapis.com/compute.googleapis.com/ssd_total_gb","value":5000,"atScale":30000},
    {"item":"compute.googleapis.com/compute.googleapis.com/local_ssd_total_storage","value":15000,"atScale":50000},
    {"item":"compute.googleapis.com/compute.googleapis.com/googleapis.com/n2_cpus","value":100,"atScale":500},
])
def get_quotas(service):
    # Create a client
    client = cloudquotas_v1.CloudQuotasClient()
    # Initialize request argument(s)
    request = cloudquotas_v1.ListQuotaInfosRequest(
        parent=f"projects/{project_id}/locations/global/services/{service}",
    )

    # Make the request
    page_result = client.list_quota_infos(request=request)

    quotas = []
    # Handle the response
    for response in page_result:
       
        if  response.metric in databricks_quotas.item.values:
            values_all_regions = response.dimensions_infos
            dimension = ""
            if response.dimensions==["region"] :
                dimension = "region"
                value_filtered_region = [k.details.value for k in values_all_regions if google_region in k.applicable_locations][0]
            elif response.dimensions==["zone"] :
                dimension = "zone"
                # TODO : FETCH THE RIGHT ZONES
                if google_zone!="":
                    value_filtered_region = [k.details.value for k in values_all_regions if google_zone in k.applicable_locations][0]
                else : 
                    quota = -1
                    for k in values_all_regions:
                        
                        for zone in k.applicable_locations:
                            if zone in google_region:
                                if k.details.value>-1 and k.details.value<quota:
                                    quota = k.details.value # PICKING THE SMALLEST QUOTA. 
                                value_filtered_region = quota
            else:
                for k in range(len(values_all_regions)):
                    if values_all_regions[k].applicable_locations==["global"]:
                        dimension = "global"
                        value_filtered_region = values_all_regions[k].details.value
                    else:
                        raise "ISSUE IN THE CODE PLANNING FOR REGIONAL QUOTAS - A QUOTA MIGHT NOT BE TRACKED"
            databricks_metrics = databricks_quotas[databricks_quotas["item"]==response.metric]
            canRun = (value_filtered_region ==-1 or value_filtered_region>=databricks_metrics.value.values[0])
            canRunAtScale = (value_filtered_region>=databricks_metrics.atScale.values[0] or value_filtered_region==-1)
            quotas.append({"name":response.name,"metric":response.metric,"service":response.service,"dimension":dimension,"metric_unit":response.metric_unit,"value":value_filtered_region,"canRun":canRun,"canRunAtScale":canRunAtScale,"atScale":databricks_metrics.atScale.values[0]})
       
    return quotas

print("FETCHING QUOTAS VALUES .....")
quotas = get_quotas(service)
df = pd.DataFrame(quotas)
if len(df[df.canRun==False])==0:
    print("QUOTAS OK TO DEPLOY DATABRICKS")
else :
    print("INSUFFICIENT QUOTAS TO DEPLOY DATABRICKS")
    print(df[df.canRun==False])
if len(df[df.canRunAtScale==False])==0:
    print("QUOTAS OK TO DEPLOY DATABRICKS AT SCALE")
else :
    print("INSUFFICIENT QUOTAS TO RUN DATABRICKS AT SCALE : ")
    print(df[df.canRunAtScale==False])

