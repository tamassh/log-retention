
class storesync {
    include storesync::install, storesync::concats, storesync::service
    Class [ "storesync::install" ] -> Class [ "storesync::concats" ] -> Class [ "storesync::service" ]
}
