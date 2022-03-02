from argparse import ArgumentParser
import strax
import straxen
import cutax
from utilix import DB
import datetime


db = DB()


def main():
    parser = ArgumentParser()
    parser.add_argument('tag', default=None, required=False)
    args = parser.parse_args()

    # get contexts
    context_list = [d for d in dir(cutax.contexts) if 'xenonnt' in d]
    for context in context_list:
        # pass cuts_for=None so that we don't track the cut lineages. They aren't saved anyway
        st = getattr(cutax.contexts, context)(cuts_for=None,
                                              _include_rucio_remote=True)
        hash_dict = {dtype: dtype_info['hash'] for dtype, dtype_info in st.provided_dtypes().items()}

        doc = dict(name=context,
                   date_added=datetime.datetime.utcnow(),
                   hashes=hash_dict,
                   straxen_version=straxen.__version__,
                   strax_version=strax.__version__,
                   cutax_version=cutax.__version__,
                   )

        if args.tag:
            doc['tag'] = args.tag

        # update the context collection using utilix + runDB_api
        db.update_context_collection(doc)

if __name__ == "__main__":
    main()
