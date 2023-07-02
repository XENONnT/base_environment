from argparse import ArgumentParser
import strax
import straxen
import cutax
from utilix import DB
import datetime


db = DB()


def main():
    parser = ArgumentParser()
    parser.add_argument('ref')
    parser.add_argument('type')
    args = parser.parse_args()

    # get name of tag/branch that started this workflow
    tag = args.ref

    # if we are on stable branch, only run this if it's a tag
    # if we are on master branch, change tag to 'development'
    if args.type == 'branch':
        if args.ref == 'stable':
            print("Only tagged commits on stable branch are updated. Exiting.")
            return
        elif args.ref == 'master':
            tag = 'development'

    # get contexts
    context_list = [d for d in dir(cutax.contexts) if 'xenonnt' in d]
    for context in context_list:
        # pass cut_list=None so that we don't track the cut lineages. They aren't saved anyway
        # skip contexts that raise errors
        
        try:
            st = getattr(cutax.contexts, context)(cut_list=None,
                                                  _include_rucio_remote=True)
        except NotImplementedError:
            print(f"Skipping {context}")
            continue

        hash_dict = {dtype: dtype_info['hash'] for dtype, dtype_info in st.provided_dtypes().items()}

        doc = dict(name=context,
                   date_added=datetime.datetime.utcnow(),
                   hashes=hash_dict,
                   straxen_version=straxen.__version__,
                   strax_version=strax.__version__,
                   cutax_version=cutax.__version__,
                   tag=tag
                   )

        # update the context collection using utilix + runDB_api
        db.update_context_collection(doc)
        if context == 'xenonnt_offline':
            # need re-add the date_added field since the `update_context_collection` function changes it to str
            doc['date_added'] = datetime.datetime.utcnow()
            doc['name'] = f'xenonnt_{cutax.contexts.DEFAULT_XEDOCS_VERSION}'
            db.update_context_collection(doc)

if __name__ == "__main__":
    main()
